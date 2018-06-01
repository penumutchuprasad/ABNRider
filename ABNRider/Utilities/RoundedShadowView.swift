//
//  RoundedShadowView.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    
    func setupViews() {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.init(white: 0.55, alpha: 0.65).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.3
        
    }
    
    
    
    
}
