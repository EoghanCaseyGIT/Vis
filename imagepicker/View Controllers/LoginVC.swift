//
//  ViewController.swift
//  imagepicker
//
//  Created by Eoghan Casey on 19/12/2017.
//  Copyright © 2017 Eoghan Casey. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import Vision
import FirebaseAuth

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    private var authUser : User? {
        return Auth.auth().currentUser
    }
    
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // Notify the user that the mail has sent or couldn't because of an error.
            })
        }
        else {
            // Either the user is not available, or the user is already verified.
        }
    }
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func createAccountTapped(_ sender: Any) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                
                self.sendVerificationMail()
                
                
                self.presentTabBar()
            })
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    return
                }
                
                if user != nil && !user!.isEmailVerified {
                    // User is available, but their email is not verified.
                    // Let the user know by an alert, preferably with an option to re-send the verification mail.
                }
                self.presentTabBar()
            })
        }
    }
    
    
    
    func presentTabBar(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"myTabBar")
        self.present(viewController, animated: true)
    }
    
}
    




