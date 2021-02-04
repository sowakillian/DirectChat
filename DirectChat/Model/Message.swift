//
//  Chat.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 03/02/2021.
//

public struct Message: Codable {
    var userName: String
    var userImageUrl: String
    var sentByMe: Bool
    var text: String

    enum CodingKeys: String, CodingKey {
        case userName
        case userImageUrl
        case sentByMe
        case text
    }
}


