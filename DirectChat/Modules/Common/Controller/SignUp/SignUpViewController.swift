//
//  SignUpViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 08/02/2021.
//

import Foundation
import UIKit
import NotificationBannerSwift

class SignUpViewController:UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emailInput: BasicInput!
    @IBOutlet weak var passwordInput: BasicInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        activityIndicator.startAnimating()
        
        guard let email = emailInput.text?.replacingOccurrences(of: " ", with: ""), let password = passwordInput.text else { return }
        AuthManager().signIn(email: email, pass: password) { error in
            if error != nil {
                self.activityIndicator.stopAnimating()
                let banner = FloatingNotificationBanner(title: "Échec de la connexion", subtitle: error?.errorMessage, style: .warning)
                banner.show(on: self, cornerRadius: 8)
            } else {
                self.activityIndicator.stopAnimating()
                
                self.performSegue(withIdentifier: "toRoomList", sender: nil)
            }
        }
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
