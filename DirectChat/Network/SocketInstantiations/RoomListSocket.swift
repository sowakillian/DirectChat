//
//  RoomListSocket.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 05/02/2021.
//

import Foundation
import Starscream

class RoomListSocket:SocketCommunicationTool {
    var roomListDidChangeClosure: (([String])->())?
    var roomList: [String] = []
    
    override init(connectionType: ConnectionType = .roomList) {
        super.init(connectionType: connectionType)
    }
    
    func listen(callBack: @escaping (([String])->())) {
        self.roomListDidChangeClosure = callBack
    }
    
    override func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
        case .connected(let headers):
            isConnected = true
            socket.write(string: "Refresh|RoomList")
            
            print("websocket of type \(connectionType) is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket of type \(connectionType) is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            self.roomList = string.components(separatedBy: "|")
            self.roomListDidChangeClosure!(string.components(separatedBy: "|"))
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
