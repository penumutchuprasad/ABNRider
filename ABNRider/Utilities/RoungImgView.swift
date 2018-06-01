
//
//  RoungImgView.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit

class RoungImgView: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        setupViews()
    }
    
    func setupViews() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    
}
