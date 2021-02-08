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
    var recipient: String
    var hour: String
    var content: String
    
    init(contentType: MessageType, sender: String, recipient: String, hour: String, content: String) {
        self.contentType = contentType
        self.sender = sender
        self.recipient = recipient
        self.hour = hour
        self.content = content
    }
    
    func toString() -> String {
        "#\(contentType.rawValue)|\(sender)|\(recipient)|\(hour)|\(content)"
    }
    
    func toData() -> Data {
        "#\(contentType.rawValue)|\(sender)|\(recipient)|\(hour)|\(content)".data(using: .utf8)!
    }
    
    static func fromString(message: String) -> MessageObject {
        let messageSplitted = message.components(separatedBy: "|")
        
        return MessageObject(contentType: MessageType(rawValue: messageSplitted[0]) ?? .error, sender: messageSplitted[1], recipient: messageSplitted[2], hour: messageSplitted[3], content: messageSplitted[4])
    }
}
