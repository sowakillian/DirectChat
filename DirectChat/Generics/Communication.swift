//
//  Communication.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 04/02/2021.
//

import Foundation

protocol CryptoSuper {
    associatedtype CryptType
    associatedtype DecryptType
    
    func crypt(data: CryptType) -> DecryptType
    func decrypt(data: DecryptType) -> CryptType
}

protocol AESProtocol:CryptoSuper {
    func crypt(data:String) -> [UInt8]
    func decrypt(data: [UInt8]) -> String
}

protocol BlowfishProtocol:CryptoSuper {
    func crypt(data:String) -> String
    func decrypt(data: String) -> String
}

class Blowfish:BlowfishProtocol {
    func crypt(data: String) -> String {
        return ""
    }
    
    func decrypt(data: String) -> String {
        return ""
    }
}

class AES:AESProtocol {
    func crypt(data: String) -> [UInt8] {
        return []
    }
    
    func decrypt(data: [UInt8]) -> String {
        return ""
    }
}

class SuperCrypto<Crypt, Decrypt>:CryptoSuper {
    
    typealias CryptType = Crypt
    typealias DecryptType = Decrypt
    
    func crypt(data: Crypt) -> Decrypt {
        
    }
    
    func decrypt(data: Decrypt) -> Crypt {
        
    }
    
}

class Communication<ExchangeType:AuthorizedEchangeType, IdentificationType>:WirelessCommunication {
    
    typealias ExchangeValue = ExchangeType
    typealias IdType = IdentificationType
    
    func scan(id: IdentificationType) {
        switch id {
        case is String:
            print("it is string")
        case is Int:
            print("it is int")
        default:
        print("nothing to scan")
        }
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

protocol DirectChatTools {
    associatedtype MyCryptType
    var cryptoTool: MyCryptType { get set }
}

class BLE<T:AuthorizedEchangeType, IdType, Crypt:CryptoSuper>:Communication<T, IdType>, DirectChatTools {
    var cryptoTool:Crypt? =  nil
}

class WIFI<T:AuthorizedEchangeType, IdType, Crypt:CryptoSuper>:Communication<T, IdType>, DirectChatTools {
    var cryptoTool:Crypt? =  nil
    
}


let tools = [ble, wifi]
let ble = BLE<String, Int, AES>()
let wifi = WIFI<Int, String, Blowfish>()

func sendDataTo<T,S>(tool: Communication<T,S>) {}

func test() {
    ble.connect(id: 55)
}
