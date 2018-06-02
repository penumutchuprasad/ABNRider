//
//  MenuVC.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import Firebase

class LeftPanelVC: UIViewController {
    
    let currentUsrId = Auth.auth().currentUser?.uid

    let appDelegate = AppDelegate.getAppDelegate()
    
    @IBOutlet var userImgView: RoundImgView!
    @IBOutlet var userAccntLbl: UILabel!
    @IBOutlet var accntTypeLbl: UILabel!
    @IBOutlet var logInOutBtn: UIButton!
    @IBOutlet var modeStatusLbl: UILabel!
    @IBOutlet var toggleSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toggleSwitch.isOn = false
        modeStatusLbl.isHidden = true
        toggleSwitch.isHidden = true
        
        if Auth.auth().currentUser == nil {
            
            accntTypeLbl.text = ""
            userAccntLbl.text = ""
            userImgView.isHidden = true
            logInOutBtn.setTitle("Signup / Login", for: .normal)
            
        } else {
            
            userAccntLbl.text = Auth.auth().currentUser?.email
            accntTypeLbl.isHidden = false
            userImgView.isHidden = false
            logInOutBtn.setTitle("Logout", for: .normal)

        }
        
        observePassengersAndDrivers()
        
    }
    
    func observePassengersAndDrivers() {
        
        //For Useres
        DataService.shared.Ref_Users.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snpshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snp in snpshot {
                    
                    if snp.key == Auth.auth().currentUser?.uid {
                        
                        self.accntTypeLbl.text = "Passenger"
                        
                    }
                    
                }
                
            }

        })
        
        //For Drivers
        
        DataService.shared.Ref_Drivers.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let snpshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                for snp in snpshot {
                    
                    if snp.key == Auth.auth().currentUser?.uid {
                        
                        self.accntTypeLbl.text = "Driver"
                        self.toggleSwitch.isHidden = false
                        self.modeStatusLbl.isHidden = false
                        
                        let switchStatus = snp.childSnapshot(forPath: "isPickupModeEnabled").value as! Bool
                        self.toggleSwitch.isOn = switchStatus
                        self.modeStatusLbl.text = switchStatus ? "Pickup mode is enabled" : "Pickup mode is disabled"
                        
                    }
                    
                }
                
            }
            
        })
        
    }
    
    
    
    @IBAction func onSwitchToggle(sender: UISwitch) {
        
        if sender.isOn {
            DataService.shared.Ref_Drivers.child(currentUsrId!).updateChildValues(["isPickupModeEnabled" : true])
            
        }else {
            DataService.shared.Ref_Drivers.child(currentUsrId!).updateChildValues(["isPickupModeEnabled" : false])
        }
        
        self.modeStatusLbl.text = sender.isOn ? "Pickup mode is enabled" : "Pickup mode is disabled"
        appDelegate.MenuContainerVC.toggleLeftPanel()
        
    }
    
    
    @IBAction func onLoginAndSignup(sender: UIButton) {
        
        if Auth.auth().currentUser == nil {
            
            if let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as?  LoginVC {
                
                self.present(loginVC, animated: true, completion: nil)
            }
            
        } else {
            
            do {
                
                try Auth.auth().signOut()
                
                toggleSwitch.isOn = false
                modeStatusLbl.isHidden = true
                toggleSwitch.isHidden = true
                userImgView.isHidden = true
                accntTypeLbl.text = ""
                userAccntLbl.text = ""
                logInOutBtn.setTitle("Signup / Login", for: .normal)

            }catch let err {
                
                print("signout error \(err)")
            }
            
            
        }
        
       
        
        
    }
    
    
    
}
