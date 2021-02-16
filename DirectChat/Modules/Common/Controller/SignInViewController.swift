//
//  SignInViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 08/02/2021.
//

import Foundation
import UIKit
import NotificationBannerSwift

class SignInViewController:UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pseudoInput: BasicInput!
    @IBOutlet weak var emailInput: BasicInput!
    @IBOutlet weak var passwordInput: BasicInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        
        if let email = emailInput.text?.replacingOccurrences(of: " ", with: ""), let password = passwordInput.text, let pseudo = pseudoInput.text?.replacingOccurrences(of: " ", with: "") {
            AuthManager().createUser(pseudo: pseudo, password: password, email: email) { error in
                if error != nil {
                    self.activityIndicator.stopAnimating()
                    print(error?.errorMessage)
                    let banner = FloatingNotificationBanner(title: "Échec de l'inscription", subtitle: error?.errorMessage, style: .warning)
                    banner.show(on: self, cornerRadius: 8)
                    
                } else {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "toChatMode", sender: nil)
                }
            }
        } else {
            let banner = FloatingNotificationBanner(title: "Échec de l'inscription", subtitle: "Merci de remplir tous les champs", style: .warning)
            banner.show(on: self, cornerRadius: 8)
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
