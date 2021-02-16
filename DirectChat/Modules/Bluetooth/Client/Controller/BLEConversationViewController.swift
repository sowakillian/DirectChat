//
//  BLEConversationViewController.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 16/02/2021.
//

import UIKit
import CryptoSwift
import AVKit
import YPImagePicker

class BLEConversationViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var contentView: UIView!
    var isConnected = false
    @IBOutlet var chatCollView: UICollectionView!
    @IBOutlet var inputViewContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var chatTF: UITextField!
    var socketRoomConnection:RoomConnectionSocket? = nil
    var pseudo = UserDefaults.standard.string(forKey: "pseudo")
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var vocalTimer: Timer!
    
    
    private(set) var messageArray: [Message] = []
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            print("cc mec")
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        
        
        self.recordButton.isEnabled = false
        self.recordButton.alpha = 0.5
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Messages"
        self.assignDelegates()
        self.manageInputEventsForTheSubViews()
        
        recordingSession = AVAudioSession.sharedInstance()

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.recordButton.isEnabled = true
                        self.recordButton.alpha = 1
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
        
        
//        print("socketRoomConnection", socketRoomConnection)
//        socketRoomConnection?.connect()
//
//        print(" i enter in view")
        
//        socketRoomConnection?.listen { messageList in
//            self.messageArray = []
//            var messageListSplitted:[[UInt8]] = []
//            var messageListIndex:Int = 0
//            var index = 0
//
//            let messageListArray = Array(messageList)
//
//            while (index < messageListArray.count) {
//                if messageListArray[index] == 35 && messageListArray[index+1] == 124 && messageListArray[index+2] == 35 {
//                    messageListIndex+=1
//                    index+=3
//                } else {
//                    if !messageListSplitted.indices.contains(messageListIndex) {
//                        messageListSplitted.append([])
//                    }
//
//                    messageListSplitted[messageListIndex].append(messageListArray[index])
//                    index+=1
//                }
//            }
//
//            print("messageListSplitted", messageListSplitted)
//            if  (messageList[0] == 0) {
//                print("no messages")
//            } else {
//                messageListSplitted.forEach { (message) in
//
//                    if let messageObject = MessageObject.fromData(message: message) {
//                        let sender = messageObject.sender
//                        let sentByMe = sender == self.pseudo ? true : false
//
//                        let messageConverted = Message(userName: messageObject.sender, userImageUrl: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2552&q=80", sentByMe: sentByMe, text: messageObject.content)
//                        self.messageArray.append(messageConverted)
//                    }
//                }
//
//                self.chatCollView.reloadData()
//                self.scrollToLastMessage()
//            }
//
//
//        }
    }
    
    @IBAction func microClicked(_ sender: Any) {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @IBAction func photoClicked(_ sender: Any) {
        var config = YPImagePickerConfiguration()
        config.wordings.libraryTitle = "Gallerie"
        config.wordings.cameraTitle = "Camera"
        config.wordings.next = "Envoyer"
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            chatTF.isEnabled = false
            
            chatTF.placeholder = "00:00"
            vocalTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateVocalTime), userInfo: nil, repeats: true)
            
            recordButton.tintColor = .red
        } catch {
            chatTF.placeholder = "Tape ton message"
            finishRecording(success: false)
            vocalTimer.invalidate()
        }
    }
    
    @objc func updateVocalTime() {
        //print("Timer fired!")
        print(audioRecorder.currentTime)
        if audioRecorder.currentTime < 10 {
            chatTF.placeholder = "00:0\(String(String(audioRecorder.currentTime).prefix(1)))"
        } else {
            chatTF.placeholder = "00:\(String(String(audioRecorder.currentTime).prefix(2)))"
        }
        
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        vocalTimer.invalidate()
        chatTF.placeholder = "Tape ton message"

        if success {
            recordButton.tintColor = UIColor.MainTheme.mainGrey
        } else {
            recordButton.tintColor = UIColor.MainTheme.mainGrey
            // recording failed :(
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
                    self.scrollToLastMessage()
                }
            })
        }
    }
    
    private func scrollToLastMessage() {
        let lastItem = self.messageArray.count-1
        
        print(self.messageArray, self.messageArray.count)
        let indexPath = IndexPath(item: lastItem, section: 0)
        print(indexPath)
        self.chatCollView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    private func assignDelegates() {
        
        self.chatCollView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
        self.chatCollView.dataSource = self
        self.chatCollView.delegate = self
        
        self.chatTF.delegate = self
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    @IBAction func onSendChat(_ sender: UIButton?) {
        guard let chatText = chatTF.text, chatText.count >= 1 else { return }
        chatTF.text = ""
        
//        socketRoomConnection?.socket.write(data: MessageObject(contentType: .string, sender: self.pseudo ?? "anonymous", receiver: "test", hour: "10h", content: chatText).toData())
        BLEManager.instance.sendData(data: MessageObject(contentType: .string, sender: self.pseudo ?? "anonymous", receiver: "test", hour: "10h", content: chatText).toData()) { (success) in
            print("messageSent")
        }
        
        let lastItem = self.messageArray.count - 1
        let indexPath = IndexPath(item: lastItem, section: 0)
        //        self.chatCollView.insertItems(at: [indexPath])
        self.chatCollView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BLEConversationViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
                cell.nameLabel.textColor = UIColor.MainTheme.white
                cell.profileImageView.frame = CGRect(x: 8, y: estimatedFrame.height - 8, width: 30, height: 30)
                cell.nameLabel.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: 18)
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 12, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16 + 12, height: estimatedFrame.height + 20 + 6)
                cell.bubbleImageView.image = MessageCell.grayBubbleImage
                cell.bubbleImageView.tintColor = UIColor.MainTheme.mainPurple
                cell.messageTextView.textColor = UIColor.white
            } else {
                
                cell.nameLabel.textAlignment = .right
                cell.nameLabel.textColor = UIColor.MainTheme.mainPurple
                cell.profileImageView.frame = CGRect(x: self.chatCollView.bounds.width - 38, y: estimatedFrame.height - 8, width: 30, height: 30)
                cell.nameLabel.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 16 - 16 - 8 - 30 - 12, y: 0, width: estimatedFrame.width + 16, height: 18)
                cell.messageTextView.frame = CGRect(x: collectionView.bounds.width - estimatedFrame.width - 16 - 16 - 8 - 30, y: 12, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: collectionView.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10 - 30, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                cell.bubbleImageView.image = MessageCell.blueBubbleImage
                cell.bubbleImageView.tintColor = UIColor.MainTheme.white
                cell.messageTextView.textColor = UIColor.black
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
        return UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
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

extension BLEConversationViewController: UITextFieldDelegate {
    
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
