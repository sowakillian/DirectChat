//
//  MessageObject.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 04/02/2021.
//

import Foundation

enum MessageType: String {
    case string = "#0"
    case image = "#1"
    case sound = "#2"
    case video = "#3"
    case error = "#666"
}

class MessageObject {
    
    var contentType: MessageType
    var sender: String
    var receiver: String
    var hour: String
    var content: String
    
    init(contentType: MessageType, sender: String, receiver: String, hour: String, content: String) {
        self.contentType = contentType
        self.sender = sender
        self.receiver = receiver
        self.hour = hour
        self.content = content
    }
    
    func toString() -> String {
        "#\(contentType.rawValue)|\(sender)|\(receiver)|\(hour)|\(content)"
    }
    
    func toData() -> Data {
        
        var message: [UInt8] = []
        
        guard let separator = "|#|".data(using: .utf8) else { return Data()  }
        
        guard let dataType = contentType.rawValue.data(using: .utf8) else { return Data()  }
        message.append(contentsOf: dataType)
        message.append(contentsOf: separator)
        
        guard let dataSender = sender.data(using: .utf8) else { return Data() }
        message.append(contentsOf: dataSender)
        message.append(contentsOf: separator)
        
        guard let dataReceiver = receiver.data(using: .utf8) else { return Data()  }
        message.append(contentsOf: dataReceiver)
        message.append(contentsOf: separator)
        
        guard let dataHour = hour.data(using: .utf8) else { return Data()  }
        message.append(contentsOf: dataHour)
        message.append(contentsOf: separator)
        
        guard let dataContent = content.data(using: .utf8) else { return Data() }
        message.append(contentsOf: dataContent)
        
        
        return Data(message)
    }
    
    static func fromData(message: [UInt8]) -> MessageObject? {
        var messageSplitted:[[UInt8]] = []
        var messageIndex:Int = 0
        var index = 0
        
        while (index < message.count) {
            if message[index] == 124 && message[index+1] == 35 && message[index+2] == 124 {
                messageIndex+=1
                index+=3
            } else {
                if !messageSplitted.indices.contains(messageIndex) {
                    messageSplitted.append([])
                }
                
                messageSplitted[messageIndex].append(message[index])
                index+=1
            }
        }
        
        if let contentType = String(bytes: messageSplitted[0], encoding: .utf8),
           let sender = String(bytes: messageSplitted[1], encoding: .utf8),
           let receiver = String(bytes: messageSplitted[2], encoding: .utf8),
           let hour = String(bytes: messageSplitted[3], encoding: .utf8),
           let content = String(bytes: messageSplitted[4], encoding: .utf8) {
            
            return MessageObject(contentType: MessageType(rawValue: contentType) ?? .error, sender: sender, receiver: receiver, hour: hour, content: content)
            
        } else {
            return nil
        }
    }
    
    static func fromString(message: String) -> MessageObject {
        let messageSplitted = message.components(separatedBy: "|")
        
        return MessageObject(contentType: MessageType(rawValue: messageSplitted[0]) ?? .error, sender: messageSplitted[1], receiver: messageSplitted[2], hour: messageSplitted[3], content: messageSplitted[4])
    }
}
