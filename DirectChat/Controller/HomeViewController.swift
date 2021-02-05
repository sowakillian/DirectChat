//
//  HomeViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 04/02/2021.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var joinRoomButton: UIButton!
    @IBOutlet weak var pseudoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        //hideLoadingView()
        self.hideKeyboardWhenTappedAround()
        
        joinRoomButton.layer.cornerRadius = 25
    }
    
    @IBAction func joinRoomListButtonClicked(_ sender: Any) {
        if let pseudo = pseudoTextField.text {
            let defaults = UserDefaults.standard
            defaults.set(pseudo, forKey: "pseudo")
            self.performSegue(withIdentifier: "toRoomList", sender: nil)
        }

    }
    
    func hideLoadingView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
               // self.loadingView.alpha = 0
            }, completion: { _ in
              //  self.loadingView.isHidden = true
            })
        }
    }
}
