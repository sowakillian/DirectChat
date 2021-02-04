//
//  RoomListViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 04/02/2021.
//

import Foundation
import UIKit

class RoomListViewController: UIViewController {
    
    @IBOutlet weak var createRoomButton: UIButton!
    @IBOutlet weak var refreshRoomListButton: UIButton!
    @IBOutlet weak var activeRoomsLabel: UILabel!
    
    let socketCreation = SocketServer(connectionType: .roomCreation)
    let socketRoomList = SocketServer(connectionType: .roomList)
    
    @IBOutlet weak var roomListTableView: UITableView!
    
    var roomList:[String] = []
    var selectedRoomId:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roomListTableView.delegate = self
        roomListTableView.dataSource = self
        
        createRoomButton.layer.cornerRadius = 15
        refreshRoomListButton.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toConversation" {
                if let dest = segue.destination as? ConversationViewController {
                    dest.socketRoomConnection = SocketServer(connectionType: .roomConnection, roomId: selectedRoomId)
                }
            }
    }
    
    @IBAction func refreshRoomListClicked(_ sender: Any) {
        socketRoomList.connect()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.roomList = self.socketRoomList.roomList
            self.roomListTableView.reloadData()
            print(self.roomList)
        }

    }
    
    @IBAction func createRoomClicked(_ sender: Any) {
        print("Create room has been clicked")
        socketCreation.connect()
    }
}

extension RoomListViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoomId = roomList[indexPath.row]
        print(selectedRoomId)
        self.performSegue(withIdentifier: "toConversation", sender: nil)
    }
}

extension RoomListViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roomList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roomListTableView.dequeueReusableCell(withIdentifier: "RoomTableViewCell") as! RoomTableViewCell
        cell.roomNumberLabel.text = "Room n°\(indexPath.row)"
        return cell
    }
    
}
