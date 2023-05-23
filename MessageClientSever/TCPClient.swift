//
//  TCPClient.swift
//  MessageClientSever
//
//  Created by Joyal Serrao on 18.05.23.
//

import Foundation
import Network

protocol Client {
    func connectToServer(host: String, port: UInt16)
    func sendMesaage(message: String)
}

final class TCPClient: Client {
    
    private var connection: NWConnection?
    var statusClient: ((StatusCode) -> Void)?

    func connectToServer(host: String, port: UInt16) {
        let parameters = NWParameters.tcp
        connection = NWConnection(host: NWEndpoint.Host(host), port: NWEndpoint.Port(rawValue: port)!, using: parameters)
        connection?.stateUpdateHandler = { newState in
            switch newState {
            case .ready:
                print("Connected to server.")
                self.statusClient?(.connected("Client connected \(host):\(port)"))
            case .failed(let error):
                print("Connection failed with error: \(error.localizedDescription)")
            default:
                break
            }
        }
        connection?.start(queue: .main)
    }
    
    func sendMesaage(message: String) {
        connection?.send(content:  Data(message.utf8), completion: .contentProcessed({ error in
            if let error = error {
                print("Failed to send data with error: \(error.localizedDescription)")
            } else {
                print("Data sent successfully.\(message)")
            }
        }))
    }
}
