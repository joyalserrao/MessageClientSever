//
//  MessageClient.swift
//  MessageClientSever
//
//  Created by Joyal Serrao on 18.05.23.
//

import Foundation

class MessageClient {
    private let client: Client
    
    init(client: Client) {
        self.client = client
    }
    
    func connectToSever() {
        client.connectToServer(host: "127.0.0.1", port: 8080)
    }
    
    func sendMessage(string: String) {
        client.sendMesaage(message: string)
    }
}
