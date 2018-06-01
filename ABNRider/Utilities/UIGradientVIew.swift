//
//  UIGradientVIew.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit

class UIGradientVIew: UIView {
    
    
    let gradient = CAGradientLayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupGradientView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupGradientView()
    }
    
    func setupGradientView() {
        self.gradient.frame = self.frame
        self.gradient.colors = [UIColor.white.cgColor, UIColor.init(white: 1.0, alpha: 0.0).cgColor]
        self.gradient.startPoint = CGPoint.zero
        self.gradient.endPoint = CGPoint(x: 0, y: 1)
        self.gradient.locations = [0.8, 1.0]
        self.layer.addSublayer(gradient)
    }
    
    
}
