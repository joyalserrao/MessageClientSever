//
//  MessageContentModifier.swift
//  MessageClientSever
//
//  Created by Joyal Serrao on 18.05.23.
//

import SwiftUI

struct MessageContentModifier: ViewModifier {
//    let isUserMessage: Bool
    
    func body(content: Content) -> some View {
        content
            .padding(8)
            .background(Color(white: 0.9))
            .cornerRadius(8)
    }
}
