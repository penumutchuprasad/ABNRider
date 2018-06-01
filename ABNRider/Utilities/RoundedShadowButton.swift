//
//  RoundedShadowButton.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit

class RoundedShadowButton: UIButton {
    
    var originalFrame: CGRect?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupViews()
    }
    
    
    func setupViews() {
        self.originalFrame = self.frame
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.gray.cgColor
        
    }
    
    func animateButton(shouldLoad: Bool, withMessage msg: String?) {
        
        let spinner = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        spinner.color = .green
        spinner.alpha = 0
        spinner.tag = 54
        spinner.hidesWhenStopped = true
        self.addSubview(spinner)
        
        if shouldLoad {
            
            self.setTitle("", for: .normal)
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.layer.cornerRadius = self.frame.height / 2
                self.frame = CGRect.init(x: self.frame.midX - (self.frame.height / 2), y: self.frame.origin.y, width: self.frame.height, height: self.frame.height)
                
            }) { (finished) in
                
                if finished {
                    spinner.startAnimating()
                    spinner.center = CGPoint(x: self.frame.width/2, y: self.frame.width/2)
                    UIView.animate(withDuration: 0.2, animations: {
                        spinner.alpha = 1.0
                    })
                }
            }
            self.isUserInteractionEnabled = false
            
        } else {
            
            self.isUserInteractionEnabled = true
            
            for vw in subviews {
                if vw.tag == 54 {
                    vw.removeFromSuperview()
                }
            }
            UIView.animate(withDuration: 0.2) {
                
                self.layer.cornerRadius = 5.0
                self.frame = self.originalFrame!
                self.setTitle(msg, for: .normal)
                
            }


        }
        
    }
    
    
    
}
