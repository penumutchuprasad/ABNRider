//
//  UIView+Extensions.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit


extension UIView {
    
    
    
    func fadeTo(alphaValue: CGFloat, withDuration duration: TimeInterval) {

        UIView.animate(withDuration: duration) {
            self.alpha = alphaValue
        }
        
    }
    
    
    func bindToKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWilChangeFrameHandler(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc func keyboardWilChangeFrameHandler(notification: Notification) {
        
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curveframe = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let deltaY = targetFrame.origin.y - curveframe.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions.init(rawValue: curve), animations: {
            self.frame.origin.y += deltaY
        }, completion: nil)
        
    }
    
    var tap: UITapGestureRecognizer {
        return UITapGestureRecognizer.init(target: self, action: #selector(onTap(sender:)))
    }
    
    func addTap() {

        self.addGestureRecognizer(tap)
        self.tap.addTarget(self, action: #selector(onTap(sender:)))
    }
    
    func removeTap() {
        
        self.removeGestureRecognizer(self.tap)
        self.tap.removeTarget(self, action: #selector(onTap(sender:)))
    }
    
    
    @objc func onTap(sender: UITapGestureRecognizer) {
        
        self.endEditing(true)
        
    }
    
}
