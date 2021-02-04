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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        //hideLoadingView()
        
        joinRoomButton.layer.cornerRadius = 25
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
