//
//  SocketCommunicationTool.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 05/02/2021.
//

import Foundation
import Starscream

class SocketCommunicationTool: SocketCommunication, WebSocketDelegate {
    var socket: WebSocket!
    var isConnected:Bool = false
    var connectionType: ConnectionType
    
    init(connectionType: ConnectionType) {
        self.connectionType = connectionType
    }
    
    func connect() {
        var request = URLRequest(url: URL(string: "http://172.20.10.2:9090/\(connectionType)")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        print("should be implemented in child")
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
}
