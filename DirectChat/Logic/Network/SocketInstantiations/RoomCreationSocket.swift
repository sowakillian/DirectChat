//
//  RoomCreationSocket.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 05/02/2021.
//

import Foundation
import Starscream

class RoomCreationSocket:SocketCommunicationTool {
    
    override init(connectionType: ConnectionType = .roomCreation) {
        super.init(connectionType: connectionType)
    }
    
    override func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
        case .connected(let headers):
            isConnected = true
            socket.write(string: "Creation|\(UUID().uuidString)")
            
            print("websocket of type \(connectionType) is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket of type \(connectionType) is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            handleError(error)
        }
        
    }
}
