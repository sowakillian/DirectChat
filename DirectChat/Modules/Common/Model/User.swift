//
//  User.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 08/02/2021.
//

import Foundation

public struct User: Codable {

    let pseudo: String
    let uid: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case pseudo
        case uid
        case email
    }
    
    init(pseudo: String, uid: String, email: String) {
        self.pseudo = pseudo
        self.uid = uid
        self.email = email
    }

}
