//
//  MessageInput.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 09/02/2021.
//

import Foundation
import UIKit

class MessageInput: UITextField {
    override init(frame: CGRect) {
        super.init(frame : frame)
        setupInput()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInput()
    }
    
    private func setupInput() {
        textColor = UIColor.MainTheme.black
        layer.cornerRadius   =  self.frame.height/2
        layer.borderWidth    = 0
    }
    
    func setText(text: String) {
        attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.MainTheme.placeholderGrey])
    }
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 40)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
