//
//  Communication.swift
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

class Communication<ExchangeType, IdentificationType>:WirelessCommunication {
    
    typealias ExchangeValue = ExchangeType
    typealias IdType = IdentificationType
    
    func scan(id: IdentificationType) {
        
    }
    
    func connect(id: IdentificationType) {
        
    }
    
    func disconnect() {
        
    }
    
    func write(callBack: ((ExchangeType) -> ())?) {
        
    }
    
    func read(callBack: ((ExchangeType) -> ())?) {
        
    }

}

let com = Communication<String, String>()

//class BLE:Communication {
//    override func scan() {
//
//    }
//
//    override func write() {
//
//    }
//}
