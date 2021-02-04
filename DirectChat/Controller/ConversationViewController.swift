//
//  ConversationViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 03/02/2021.
//

import UIKit

class ConversationViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    var isConnected = false
    @IBOutlet var chatCollView: UICollectionView!
    @IBOutlet var inputViewContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var chatTF: UITextField!
    var socketRoomConnection:SocketServer? = nil
    
    private(set) var messageArray: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Messages"
        self.assignDelegates()
        self.manageInputEventsForTheSubViews()
        
        socketRoomConnection?.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchChatData()
    }
    
    private func fetchChatData() {
        
        let spinner = Spinner.init()
        spinner.show()
        
        if let url = Bundle.main.url(forResource: "message", withExtension: "json") {
            
            DispatchQueue.main.async {
                spinner.hide()
            }
            do {
                
                let data = try Data.init(contentsOf: url)
                let decoder = JSONDecoder.init()
                self.messageArray = try decoder.decode([Message].self, from: data)
                self.chatCollView.reloadData()
                
            } catch let err {
                print(err.localizedDescription)
            }
            
        }
    }
    
    private func manageInputEventsForTheSubViews() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeNotfHandler(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardFrameChangeNotfHandler(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            inputViewContainerBottomConstraint.constant = isKeyboardShowing ? keyboardFrame.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    let lastItem = self.messageArray.count - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.chatCollView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    private func assignDelegates() {
        
        self.chatCollView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
        self.chatCollView.dataSource = self
        self.chatCollView.delegate = self
        
        self.chatTF.delegate = self
    }
    
    @IBAction func onSendChat(_ sender: UIButton?) {
        
        guard let chatText = chatTF.text, chatText.count >= 1 else { return }
        chatTF.text = ""
        let chat = Message.init(userName: "Krish", userImageUrl: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2552&q=80", sentByMe: false, text: chatText)
        
        self.messageArray.append(chat)
        self.chatCollView.reloadData()
        
        let lastItem = self.messageArray.count - 1
        let indexPath = IndexPath(item: lastItem, section: 0)
        //        self.chatCollView.insertItems(at: [indexPath])
        self.chatCollView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
}

extension ConversationViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = chatCollView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell {
            
            let chat = messageArray[indexPath.item]
            
            cell.messageTextView.text = chat.text
            cell.nameLabel.text = chat.userName
            cell.profileImageURL = URL.init(string: chat.userImageUrl)!
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            var estimatedFrame = NSString(string: chat.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            estimatedFrame.size.height += 18
            
            let nameSize = NSString(string: chat.userName).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)], context: nil)
            
            let maxValue = max(estimatedFrame.width, nameSize.width)
            estimatedFrame.size.width = maxValue
            
            
            if chat.sentByMe {
                
                cell.nameLabel.textAlignment = .left
                cell.profileImageView.frame = CGRect(x: 8, y: estimatedFrame.height - 8, width: 30, height: 30)
                cell.nameLabel.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: 18)
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 12, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16 + 12, height: estimatedFrame.height + 20 + 6)
                cell.bubbleImageView.image = MessageCell.grayBubbleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = UIColor.black
            } else {
                
                cell.nameLabel.textAlignment = .right
                cell.profileImageView.frame = CGRect(x: self.chatCollView.bounds.width - 38, y: estimatedFrame.height - 8, width: 30, height: 30)
                cell.nameLabel.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 16 - 16 - 8 - 30 - 12, y: 0, width: estimatedFrame.width + 16, height: 18)
                cell.messageTextView.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 16 - 16 - 8 - 30, y: 12, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10 - 30, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                cell.bubbleImageView.image = MessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messageTextView.textColor = UIColor.white
            }
            
            return cell
        }
        
        return MessageCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let chat = messageArray[indexPath.item]
        if let chatCell = cell as? MessageCell {
            chatCell.profileImageURL = URL.init(string: chat.userImageUrl)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let chat = messageArray[indexPath.item]
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        var estimatedFrame = NSString(string: chat.text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        estimatedFrame.size.height += 18
        
        return CGSize(width: chatCollView.frame.width, height: estimatedFrame.height + 20)
    }
    
}

extension ConversationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let txt = textField.text, txt.count >= 1 {
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.resignFirstResponder()
        onSendChat(nil)
    }
}

