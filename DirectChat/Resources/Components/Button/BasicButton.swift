//
//  BasicButton.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 08/02/2021.
//

import Foundation
import UIKit


class BasicButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    func setupButton() {
        setTitleColor(UIColor.MainTheme.white, for: .normal)
        backgroundColor      = UIColor.MainTheme.mainBlue
        layer.cornerRadius   = self.frame.height/2
        layer.borderWidth    = 0
    }
    
    func setTransparentButton() {
        setTitleColor(UIColor.white, for: .normal)
        //backgroundColor = UIColor.MainTheme.transparent
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
    func setDisabled() {
        alpha = 0.3
    }
    
    func setEnabled() {
        alpha = 1
    }
    
    
    public func setShadow(shadowColor: CGColor, radius: CGFloat? = nil, opacity: Float? = nil) {
        layer.shadowColor   = shadowColor
        layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius  = radius ?? 4
        layer.shadowOpacity = opacity ?? 0.6
        clipsToBounds       = true
        layer.masksToBounds = false
    }
    
    func applyGradientButton(colors: [CGColor]) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        gradientLayer.cornerRadius = self.frame.height/2
        self.layer.insertSublayer(gradientLayer, at: 0)
        self.contentVerticalAlignment = .center
    }

}
