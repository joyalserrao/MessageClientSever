//
//  TCPServer.swift
//  MessageClientSever
//
//  Created by Joyal Serrao on 18.05.23.
//

import Foundation
import Network

protocol Server {
  func startServer()
  func stopServer()
}

enum StatusCode {
  case connected(String)
  case disconnected(String)
}

final class TCPServer: Server {
    private var listener: NWListener?
    private var connections: [NWConnection] = []
    var messageRecciver: ((String) -> Void)?
    var statusServer: ((StatusCode) -> Void)?
    
    func startServer() {
        let parameters = NWParameters.tcp
        listener = try? NWListener(using: parameters, on: 8080)
        listener?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("Server started")
                self.statusServer?(.connected("Server started port 8080"))
            case .cancelled:
                self.statusServer?(.disconnected("Discoonnected"))
            case .failed(let error):
                print("Server failure, error: \(error.localizedDescription)")
            default:
                break
            }
        }
        
        listener?.newConnectionHandler = { newConnection in
            newConnection.start(queue: .main)
            
            newConnection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    print("Client connected")
                    self.handleWebSocketConnection(connection: newConnection)
                case .cancelled:
                    self.statusServer?(.disconnected("Stop Server"))
                case .failed(let error):
                    print("Connection failure, error: \(error.localizedDescription)")
                default:
                    break
                }
            }
        }
        listener?.start(queue: .main)
        
    }
    
    
    private func handleWebSocketConnection(connection: NWConnection) {
        connections.append(connection)
        
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, isComplete, error in
            if let data = data, !data.isEmpty {
                let receivedMessage = String(data: data, encoding: .utf8)
                print("Received message from client: \(receivedMessage ?? "")")
                self.messageRecciver?(receivedMessage ?? "")
            }
            
            if isComplete {
                print("Received all data from client. Closing connection.")
                self.closeConnection(connection: connection)
            } else if let error = error {
                print("Error in receiving data: \(error.localizedDescription)")
                self.closeConnection(connection: connection)
            } else {
                // Continue handling the connection
                self.handleWebSocketConnection(connection: connection)
            }
        }
    }
    
    private func closeConnection(connection: NWConnection) {
        if let index = self.connections.firstIndex(of: connection) {
            self.connections.remove(at: index)
        }
        connection.cancel()
    }
    
    func stopServer() {
        connections.forEach { $0.cancel() }
        connections.removeAll()
        listener?.cancel()
    }
}

extension NWConnection: Equatable {
    public static func ==(lhs: NWConnection, rhs: NWConnection) -> Bool {
        return lhs.endpoint == rhs.endpoint
    }
}
