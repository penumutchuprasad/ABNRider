//
//  ContainerVC.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import QuartzCore

protocol CenterVCDelegate {
    
    func toggleLeftPanel()
    func addLeftPanelVC()
    func animateLeftPanleVC(shouldExpand: Bool)
    
}


class ContainerVC: UIViewController {
    
    enum SlideOutState {
        case collapsed
        case leftPanelOpened
    }
    
    enum ShowWhichVC {
        case homeVc
        case mapVC
    }
    
    var showVC: ShowWhichVC = .homeVc
    var homeVC: HomeVC!
    var leftVC: LeftPanelVC!
    
    var isHidden: Bool = false
    let centerPanelExpandedOffset: CGFloat = 100
    
    var centerVC: UIViewController!
    
    var currentState: SlideOutState = .collapsed {
        
        didSet{
            self.shouldShowShadowForCenterVC(status: (currentState != .collapsed))
        }
        
    }
    var tap: UITapGestureRecognizer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCenter(screen: showVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    
    func initCenter(screen: ShowWhichVC) {
        
        var presentingController: UIViewController
        showVC = screen
        
        if homeVC == nil {
            homeVC = UIStoryboard.homeVc()
            homeVC.delegate = self
        }
        
        presentingController = homeVC
        
        if let cntrVC = centerVC {
            cntrVC.view.removeFromSuperview()
            cntrVC.removeFromParentViewController()
        }
        
        centerVC = presentingController
        
        view.addSubview(centerVC.view)
        self.addChildViewController(centerVC)
        centerVC.didMove(toParentViewController: self)

    }
    
    
    func addChildPanelVC(_ sidePanelVC: LeftPanelVC) {
        view.insertSubview(sidePanelVC.view, at: 0)
        addChildViewController(sidePanelVC)
        sidePanelVC.didMove(toParentViewController: self)
    }

    
    func animateStatusBar() {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.setNeedsStatusBarAppearanceUpdate()
            
        }, completion: nil)
        
    }
    
    func setupWhiteCoverView() {
        
        let whiteCoverView = UIView(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        whiteCoverView.alpha = 0.0
        whiteCoverView.backgroundColor = .white
        whiteCoverView.tag = 23
        
        self.centerVC.view.addSubview(whiteCoverView)
        
        UIView.animate(withDuration: 0.20) {
            
            whiteCoverView.alpha = 0.75
            
        }
        
        tap = UITapGestureRecognizer.init(target: self, action: #selector(animateLeftPanleVC(shouldExpand:)))
        tap.numberOfTapsRequired = 1
        
        self.centerVC.view.addGestureRecognizer(tap)
        
    }
    
    func hideWhiteCoverView() {
        
        centerVC.view.removeGestureRecognizer(tap)
        
        for whtView in self.centerVC.view.subviews {
            if whtView.tag == 23 {
                
                UIView.animate(withDuration: 0.20, animations: {
                    
                    whtView.alpha = 0.0
                    
                }) { (_) in
                    
                    whtView.removeFromSuperview()
                    
                }
                
            }
        }
        
        
    }
    
    func animateCenterPanelXPositionWith(targetPosition: CGFloat,completionHandler:((Bool)->Void)! = nil) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.centerVC.view.frame.origin.x = targetPosition
            
        }, completion: completionHandler)
        
        
    }
    
    func shouldShowShadowForCenterVC(status: Bool) {
        
        if status {
            
            centerVC.view.layer.opacity = 0.6
            
        } else {
            
            centerVC.view.layer.opacity = 1.0

        }
        
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return isHidden
    }
    
}




extension ContainerVC: CenterVCDelegate {
    
    
    func toggleLeftPanel() {
        
        let notAlreadyExpanded = (currentState != .leftPanelOpened)
        
        if notAlreadyExpanded {
            addLeftPanelVC()
        }
        
        animateLeftPanleVC(shouldExpand: notAlreadyExpanded)
        
    }
    
    func addLeftPanelVC() {
        
        if leftVC == nil {
            leftVC = UIStoryboard.leftSidePanelVC()
        }
        
       addChildPanelVC(leftVC)
        
    }
    
    @objc func animateLeftPanleVC(shouldExpand: Bool) {
        
        if shouldExpand {
            
            isHidden = !isHidden

            animateStatusBar()
            setupWhiteCoverView()
            
            currentState = .leftPanelOpened
            animateCenterPanelXPositionWith(targetPosition: centerVC.view.frame.width - centerPanelExpandedOffset)

        } else {
            
            isHidden = !isHidden

            animateStatusBar()
            hideWhiteCoverView()
            
            self.currentState = .collapsed

            animateCenterPanelXPositionWith(targetPosition: 0) { (finished) in
                if finished {
                    self.leftVC = nil
                }
            }

        }
        
        
    }
    
    
    
    
}



private extension UIStoryboard {
    
    class func mainStoryboard()->UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: Bundle.main)
    }
    
    class func leftSidePanelVC() -> LeftPanelVC? {
        return mainStoryboard().instantiateViewController(withIdentifier: "LeftPanelVC") as? LeftPanelVC
    }
    
    class func homeVc() -> HomeVC?{
        return mainStoryboard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
    }
    
}
