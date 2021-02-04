//
//  WirelessCommunication.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 04/02/2021.
//

import Foundation

protocol WirelessCommunication {
    associatedtype ExchangeValue
    associatedtype IdType
    
    func scan(id:IdType)
    func connect(id:IdType)
    func disconnect()
    func write(callBack:((ExchangeValue)->())?)
    func read(callBack:((ExchangeValue)->())?)
}
