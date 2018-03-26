//
//  LoginVC.swift
//  imagepicker
//
//  Created by Eoghan Casey on 19/12/2017.
//  Copyright © 2017 Eoghan Casey. All rights reserved.
//

import Foundation
import UIKit
import CoreML
import Vision
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var verifyMessage: UITextView!
    @IBOutlet weak var loginError: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not to interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
    }
    
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    public var authUser : User? {
        return Auth.auth().currentUser
    }
    
    
    public func sendVerificationMail() {
        if self.authUser != nil && !self.authUser!.isEmailVerified {
            self.authUser!.sendEmailVerification(completion: { (error) in
                // create the alert
                let alert = UIAlertController(title: "Hello!", message: "We have sent a verification email to you!.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            })
        }
        else {
            
                
                // create the alert
            let alert = UIAlertController(title: "Error", message: "We encountered an error. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func createAccountTapped(_ sender: Any) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { user, error in
                
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    // create the alert
                    let alert = UIAlertController(title: "Houston, we got a problem.", message: "You need to enter a unique email and password. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    
//                    self.loginError.text = "Your email address is already in use. Please try again."
                    return
                }
                
                self.sendVerificationMail()
                self.helpPressed()
            })
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            
            Auth.auth().signIn(withEmail: email, password: password, completion: {(user, error) in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    // create the alert
                    let alert = UIAlertController(title: "Houston, we got a problem.", message: "Incorrect Email or Password entered. Please try again.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                if user != nil && !user!.isEmailVerified {
                    // User is available, but their email is not verified.
                    // Let the user know by an alert, preferably with an option to re-send the verification mail.
                    // create the alert
                    let alert = UIAlertController(title: "Houston, we got a problem.", message: "You need to verify your email.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
                    
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
                    return
                    
                }
                self.presentTabBar()
            })
        }
    }
    
    func helpPressed(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ItemInstructions = storyboard.instantiateViewController(withIdentifier: "ItemInstructions")
        present(ItemInstructions, animated: true, completion: nil)
    }
    
    func presentTabBar(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"myTabBar")
        self.present(viewController, animated: true)
    }
    
}
    




