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
    }
    
    @IBAction func launchServerClicked(_ sender: Any) {
        if let serverNameTF = serverNameTextField.text {
            // Définition du nom advertisé
            periph.advertizedName = serverNameTF
            // Démarrage de l'advertising (le device émet son nom)
            periph.startAdvertising()
            
            if let dataAvailable = "Superbe!".data(using: .utf8) {
                // on rend cette chaine disponible dans la charactéristique...
                // Il suffit au client de venir lire régulièrement dans cette char...
                periph.availableDatas = dataAvailable
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
            }
        }
    }
}
