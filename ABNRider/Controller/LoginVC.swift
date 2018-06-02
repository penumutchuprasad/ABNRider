//
//  LoginVC.swift
//  ABNRider
//
//  Created by penumutchu.prasad@gmail.com on 01/06/18.
//  Copyright © 2018 abnboys. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    
    
   @IBOutlet var emailField: RoundedCornerTF!
   @IBOutlet var passwordField: RoundedCornerTF!
   @IBOutlet var segmntedControl: UISegmentedControl!
   @IBOutlet var authButton: RoundedShadowButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()


        view.bindToKeyboard()
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.removeTap()
    }
    
    
    @IBAction func onCancel(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onCreateOrLogin(sender: RoundedShadowButton) {
        
        
        if emailField.text != nil && passwordField.text != nil {
            self.view.endEditing(true)
            authButton.animateButton(shouldLoad: true, withMessage: nil)
            
            if let email = emailField.text! as? String, let password = passwordField.text! as? String {
                
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    
                    if error == nil { // Success...
                        
                        if let user = result?.user {
                            
                            if self.segmntedControl.selectedSegmentIndex == 0 {
                                
                                let userData = ["provider":user.providerID] as [String:Any]
                                
                                DataService.shared.createFireBaseDBUser(WithUid: user.uid, userData: userData, isDriver: false)
                            } else {
                                
                                let driverData = ["provider":user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverIsOnTrip": false] as [String:Any]
                                
                                DataService.shared.createFireBaseDBUser(WithUid: user.uid, userData: driverData, isDriver: true)
                                
                            }
                            
                            print("Auth is successful")
                            self.dismiss(animated: true, completion: nil)
                        }
                        
                    } else { // Got error ... means User Not yet created
                        
                        if let errorCode = AuthErrorCode.init(rawValue: error!._code) {
                            
                            switch errorCode {
                                
                            case .invalidEmail:
                                print("Invalid email")
                            case .emailAlreadyInUse:
                                print("Already in use email")
                            case .wrongPassword:
                                print("Wrong Password")
                            case .networkError:
                                print("Network error")
                            default:
                                print("Default cAse error")
                                
                            }
                            
                        }
                            
                            Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
                                
                                if error != nil {
                                    
                                    if let errorCode = AuthErrorCode.init(rawValue: error!._code) {
                                        
                                        switch errorCode {
                                        case .emailAlreadyInUse:
                                            print("Already in use email")
                                        case .networkError:
                                            print("Network error")
                                        default:
                                            print("Default cAse error")
                                            
                                        }
                                        
                                    }
                                } else { // Created Succsfully
                                    
                                    if let user = result?.user {
                                        
                                        if self.segmntedControl.selectedSegmentIndex == 0 {
                                            
                                            let userData = ["provider":user.providerID] as [String:Any]
                                            
                                            DataService.shared.createFireBaseDBUser(WithUid: user.uid, userData: userData, isDriver: false)
                                        } else {
                                            
                                            let driverData = ["provider":user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverIsOnTrip": false] as [String:Any]
                                            
                                            DataService.shared.createFireBaseDBUser(WithUid: user.uid, userData: driverData, isDriver: true)
                                            
                                        }
                                        
                                    }
                                    print("Successfully created")
                                    self.dismiss(animated: true, completion: nil)
                                }
                                
                            })
                            
                        }
                    
            
                    
                }
                
                
            }

        }
        
        
    }
    
    
    
    
    
    
    
    

}
