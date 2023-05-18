//
//  MessageDashboard.swift
//  MessageClientSever
//
//  Created by Joyal Serrao on 17.05.23.
//

import SwiftUI

struct MessageDashboard: View {
    @ObservedObject private var viewModel = MessageDashboardViewModel()
    
    var body: some View {
        VStack {
            Button(viewModel.statusOfSever ? "Disconnect":"Connect") {
                
                viewModel.statusOfSever ? viewModel.disconnectSever() : viewModel.configSeverCleint()
            }
            HStack {
                TextField("Type here..", text: $viewModel.newMessage)
                    .frame(height: 44)
                    .background(Color.gray)
                Button("Send") {
                    viewModel.sendMessage(text: viewModel.newMessage)
                }
            }
            VStack {
                Text("--- Client Sent Message ---")
                List(viewModel.messagesSent.reversed()) { message in
                    Text(message.content).modifier(MessageContentModifier())
                }
            }.background(Color.gray)
            VStack {
                Text("--- Sever Reccived Message ---")
                List(viewModel.messagesRecive.reversed()) { message in
                    Text(message.content).modifier(MessageContentModifier())
                    
                }
            }.background(Color.gray)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MessageDashboard()
    }
}
