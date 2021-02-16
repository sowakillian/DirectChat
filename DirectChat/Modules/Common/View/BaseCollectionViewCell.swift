//
//  BaseCollectionViewCell.swift
//  DirectChat
//
//  Created by SOWA KILLIAN on 03/02/2021.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    /**
     * Overriding a parent method does nothing, but could use for intialising subviews
     * This will be called on at the time of cell intialisation
     */
    func setupViews() {
        
    }
}
