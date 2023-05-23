//
//  MessageSever.swift
//  MessageClientSever
//
//  Created by Joyal Serrao on 18.05.23.
//

import Foundation

class MessageSever {
    private let sever: Server
    
    init(sever: Server) {
        self.sever = sever
    }
    
    func startSever() {
        self.sever.startServer()
    }
    
    func stopSever() {
        self.sever.stopServer()
    }
}
