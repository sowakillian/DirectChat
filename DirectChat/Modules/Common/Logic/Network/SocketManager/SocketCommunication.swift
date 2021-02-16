//
//  SocketCommunication.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 05/02/2021.
//

import Foundation

protocol SocketCommunication {
    
    var connectionType: ConnectionType { get set }
    var isConnected: Bool { get set }
    
    func connect()
    
}
