//
//  CardDetailsVC.swift
//  imagepicker
//
//  Created by Eoghan Casey on 28/02/2018.
//  Copyright © 2018 Eoghan Casey. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CardDetailsVC: UIViewController {
    
    var refCard: DatabaseReference!
    
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expiryDateTextField: UITextField!
    @IBOutlet weak var CVSTextField: UITextField!
    @IBOutlet weak var labelMessage: UILabel!
    
    
    @IBAction func addCard(_ sender: Any) {
        addCard()
    }
    
    
    @IBAction func finishPressed(_ sender: Any) {
        finished()
        
    }
    
    func finished(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profile = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
        present(profile, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
        
        refCard = Database.database().reference().child("cards");
    }
    
    func addCard(){
        
        
        let key = Auth.auth().currentUser?.uid
        
        let card = ["id":key,
                    "cardNumber": cardNumberTextField.text! as String,
                    "expiryDate": expiryDateTextField.text! as String,
                    "CVSNumber": CVSTextField.text! as String
        ]
        
        refCard.child(key!).setValue(card)
        
        // create the alert
        let alert = UIAlertController(title: "", message: "Your card details have been added/updated.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
        
        
}

