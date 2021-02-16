//
//  ScanServiceViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 16/02/2021.
//

import Foundation
import UIKit
import CoreBluetooth

class ScanServiceViewController:UIViewController {
    @IBOutlet weak var serviceTextField: UITextField!
    var periph: CBPeripheral?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serviceTextField.text = "uu"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? BLEConversationViewController {
            dest.chatType = "client"
        }
    }
    
    @IBAction func scanServiceClicked(_ sender: Any) {
        if let serviceTF = serviceTextField.text {
            BLEManager.instance.scan { periph, name  in
                print(periph, name)
                if name == serviceTF {
                    BLEManager.instance.stopScan()
                    BLEManager.instance.connectPeripheral(periph) { per in
                        self.periph = periph
                        
                        BLEManager.instance.discoverPeripheral(per) { (periphReady) in
                            self.performSegue(withIdentifier: "toConversation", sender: nil)
                        }
                    }
                }
            }
        }
    }
}
