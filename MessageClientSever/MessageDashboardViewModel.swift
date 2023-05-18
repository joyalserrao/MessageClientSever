//
//  MessageDashboardViewModel.swift
//  MessageClientSever
//
//  Created by Joyal Serrao on 18.05.23.
//

import Foundation

class MessageDashboardViewModel: ObservableObject {
    @Published var messagesSent: [Message] = []
    @Published var messagesRecive: [Message] = []
    @Published var newMessage: String = ""
    @Published var statusOfSever: Bool = false
    
    //TODO:- sttaus message display
    @Published var connectionsStatusInfo: String = ""


    lazy var tcpSever = TCPServer()
    lazy var tcpClient = TCPClient()
    
    var messageSever: MessageSever?
    var messageClient: MessageClient?

    func configSeverCleint() {
     
      self.configSever()
      //Config Client on localhost port 8080
      messageClient = MessageClient(client: tcpClient)
      messageClient?.connectToSever()
    }
    
    //MARK: Config Sever
    func configSever() {
      //sever start
      messageSever = MessageSever(sever: tcpSever)
      messageSever?.startSever()
      
      //Sever status
      tcpSever.statusServer = { status in
        switch status {
        case .disconnected(let message):
          self.statusOfSever = false
          self.connectionsStatusInfo = message
        case .connected(let message):
          self.statusOfSever = true
          self.connectionsStatusInfo = message
        }
      }
    
      //Sever reccive Message
      tcpSever.messageRecciver = { recciveMessage in
        let message = Message(content: recciveMessage, isUserMessage: true)
        self.messagesRecive.append(message)
      }
    }
    
    //MARK: Sent from Client
    func sendMessage(text: String) {
      messageClient?.sendMessage(string: text)
      guard !newMessage.isEmpty else { return }
      let message = Message(content: newMessage, isUserMessage: true)
      messagesSent.append(message)
    }

    func disconnectSever() {
      self.messageSever?.stopSever()
    }
}
