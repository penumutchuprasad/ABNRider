//
//  RoundedCornerTF.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit

class RoundedCornerTF: UITextField {
    
    
    var textRectOffset: CGFloat = 20
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    
    
    func setupViews() {
        
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: 0+textRectOffset, y: 0+(textRectOffset/2), width: self.frame.width - textRectOffset, height: self.frame.height+textRectOffset)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: 0+textRectOffset, y: 0+(textRectOffset/2), width: self.frame.width - textRectOffset, height: self.frame.height+textRectOffset)
    }
    
    
    
    
    
}
