//
//  SignUpViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 08/02/2021.
//

import Foundation
import UIKit

class SignUpViewController:UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func signInClicked(_ sender: Any) {
        activityIndicator.startAnimating()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
