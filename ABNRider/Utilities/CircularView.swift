//
//  CircularView.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit

@IBDesignable
class CircularView: UIView {
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        
        didSet{
            setupViews()
        }
        
    }

    @IBInspectable var borderColor: UIColor = .cyan {
        
        didSet{
            setupViews()
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    
    func setupViews() {
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor.cgColor
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    
}
