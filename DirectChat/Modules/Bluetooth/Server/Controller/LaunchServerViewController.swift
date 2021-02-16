//
//  LaunchServerViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 16/02/2021.
//

import Foundation
import UIKit

class LaunchServerViewController:UIViewController {
    @IBOutlet weak var serverNameTextField: UITextField!
    var periph = CustomPeriph()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? BLEConversationViewController {
            dest.chatType = "server"
        }
    }
    
    @IBAction func launchServerClicked(_ sender: Any) {
        if let serverNameTF = serverNameTextField.text {
            // Définition du nom advertisé
            periph.advertizedName = serverNameTF
            // Démarrage de l'advertising (le device émet son nom)
            periph.startAdvertising { (success) in
                self.performSegue(withIdentifier: "toConversation", sender: nil)
            }

            
            periph.centralDidReadDataCallBack = { data in
                print("didRead")
                print(data)
                let str = String(decoding: data, as: UTF8.self)
                print(str)
            }
            
            periph.centralDidWriteDataCallBack = { data in
                print("didWrite")
                print(data)
                let str = String(decoding: data, as: UTF8.self)
                print(str)
                
                self.periph.availableDatas = data
            }
        }
    }
}
