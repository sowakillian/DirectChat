//
//  SocketCommunication.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 04/02/2021.
//

import Foundation
import Starscream

class SocketServer: WebSocketDelegate {
    var socket: WebSocket!
    var isConnected:Bool = false
    var connectionType: ConnectionType
    var roomList: [String] = []

    var roomId:String?
    
    init(connectionType: ConnectionType, roomId: String? = nil) {
        self.connectionType = connectionType
        self.roomId = roomId
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            
            print(connectionType)
            if connectionType == .roomCreation {
                socket.write(string: "Creation|\(UUID().uuidString)")
            }
            
            if connectionType == .roomList {
                socket.write(string: "Refresh|RoomList")
            }
            
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket of type \(connectionType) is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            if connectionType == .roomList {
                self.roomList = string.components(separatedBy: "|")
            }
            
            if connectionType == .roomConnection {
                
            }
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
    
    func handleError(_ error: Error?) {
        if let e = error as? WSError {
            print("websocket encountered an error: \(e.message)")
        } else if let e = error {
            print("websocket encountered an error: \(e.localizedDescription)")
        } else {
            print("websocket encountered an error")
        }
    }
    
    func connect() {
        print("Trying to create a room list")
        var endPoint:String
        
        switch connectionType {
        case .roomCreation:
            endPoint = "roomCreation"
        case .roomList:
            endPoint = "roomList"
        case .roomConnection:
            endPoint = roomId!
        }
        
        var request = URLRequest(url: URL(string: "http://172.20.10.2:9098/\(endPoint)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
}
