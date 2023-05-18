//
//  Message.swift
//  MessageClientSever
//
//  Created by Joyal Serrao on 18.05.23.
//

import Foundation

struct Message: Identifiable {
    let id = UUID()
    let content: String
    let isUserMessage: Bool
}
