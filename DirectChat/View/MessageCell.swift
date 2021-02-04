//
//  MessageCell.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 03/02/2021.
//

import UIKit

class MessageCell: BaseCollectionViewCell {
    
    static let identifier = String(describing: MessageCell.self)
    
    private var imageCache = NSCache<NSString, UIImage>()
    var profileImageURL: URL? {
        didSet{
            self.fetchProfileImage(from: profileImageURL!)
        }
    }
    
    func fetchProfileImage(from url: URL) {
        
        //If image is available in cache, use it
        if let img = self.imageCache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                self.profileImageView.image = img
            }
            //Otherwise fetch from remote and cache it for futher use
        } else {
            
            let session = URLSession.init(configuration: .default)
            session.dataTask(with: url) { (data, response, error) in
                DispatchQueue.main.async {
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.profileImageView.image = img
                            self.imageCache.setObject(img, forKey: url.absoluteString as NSString)
                        }
                    }
                }
                }.resume()
        }
    }
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    var textBubbleView: UIView = {
        let view = UIView()
        //        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.image = #imageLiteral(resourceName: "sendIcon")
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = MessageCell.blueBubbleImage
        imageView.tintColor = UIColor(white: 0.90, alpha: 1)
        return imageView
    }()
    
    var nameLabel: UILabel = {
        
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        lbl.font = UIFont.boldSystemFont(ofSize: 15)
        return lbl
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(nameLabel)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        profileImageView.backgroundColor = UIColor.green
        
        textBubbleView.addSubview(bubbleImageView)
        addConstraintsWithVisualStrings(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithVisualStrings(format: "V:|[v0]|", views: bubbleImageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.profileImageView.image = nil
        self.messageTextView.text = nil
    }
}
