//
//  AuthManager.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 08/02/2021.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import UIKit

class AuthManager {
    
    let db = Firestore.firestore()
    
    func createUser(pseudo: String, password: String, email: String, completionHandler: @escaping (_ error: AuthErrorCode?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
            if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                print("error", error)
                completionHandler(errorCode)
            } else {
                if let user = authResult?.user {
                    let userObject = User(pseudo: pseudo, uid: user.uid, email: email)
                    
                    self.db.collection("users").document(user.uid).setData([
                        "pseudo": userObject.pseudo,
                        "email": userObject.email,
                        "uid": userObject.uid,
                    ])
                    completionHandler(nil)
                } else {
                    completionHandler(.wrongPassword)
                    
                }
            }
        }
    }
    
    func signIn(email: String, pass: String, completionHandler: @escaping (_ error: AuthErrorCode?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let errorCode = AuthErrorCode(rawValue: error._code) {
                print("Connection failed", error)
                completionHandler(errorCode)
            } else {
                print("Connection success")
                completionHandler(nil)
            }
        }
    }
    
    func signOut(completionBlock: @escaping (_ success: Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completionBlock(true)
        } catch let signOutError as NSError {
            completionBlock(false)
          print ("Error signing out: %@", signOutError)
        }
    }

}
