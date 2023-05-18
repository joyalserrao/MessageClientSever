//
//  MessageClientSeverTests.swift
//  MessageClientSeverTests
//
//  Created by Joyal Serrao on 17.05.23.
//

import XCTest
@testable import MessageClientSever

final class MessageClientSeverTests: XCTestCase {
    
    func testSeverConnection() {
        let expectation = XCTestExpectation(description: "Server status")

       let tcpSever = TCPServer()
       let mockSever = MockMessageSever(sever: tcpSever)

       tcpSever.statusServer = { status in
            switch status {
            case .connected(_):
                expectation.fulfill()
            case .disconnected(_):
                XCTFail("Server disconnected with error:")
            }
        }
        
      mockSever.startSever()
      wait(for: [expectation], timeout: 5.0)
    }
}

class MockMessageSever: MessageSever {}
