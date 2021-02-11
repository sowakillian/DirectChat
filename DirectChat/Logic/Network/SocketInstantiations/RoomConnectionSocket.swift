//
//  RoomConnectionSocket.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 05/02/2021.
//

import Foundation
import Starscream

class RoomConnectionSocket:SocketCommunicationTool {
    var newMessageClosure: ((Data)->())?
    var roomId: String
    
    init(roomId: String, connectionType: ConnectionType = .roomConnection) {
        self.roomId = roomId
        super.init(connectionType: connectionType)
    }
    
    override func connect() {
        print(self.roomId)
        var request = URLRequest(url: URL(string: "http://192.168.0.6:9074/\(roomId)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        //print("Timer fired!")
        socket.write(string: "Update|\(roomId)")
    }
    
    override func didReceive(event: WebSocketEvent, client: WebSocket) {
        
        switch event {
        case .connected(let headers):
            isConnected = true
            
            socket.write(string: "Connection|\(roomId)")
            startTimer()
            print("websocket of type \(connectionType) is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket of type \(connectionType) is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            self.newMessageClosure!(data)
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
    
    func listen(callBack: @escaping ((Data)->())) {
        self.newMessageClosure = callBack
    }
}
