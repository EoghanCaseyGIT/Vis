//
//  ProfileViewController.swift
//  imagepicker
//
//  Created by Eoghan Casey on 15/01/2018.
//  Copyright © 2018 Eoghan Casey. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import LocalAuthentication

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var uploadImageButtonCenter: CGPoint!
    var profileButtonCenter: CGPoint!
    var cardButtonCenter: CGPoint!
    var doorButtonCenter: CGPoint!
    
    
    //variables
    let databaseRef = Database.database().reference()

    
    //outlets
    @IBOutlet weak var settings: UIButton!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var profile: UIButton!
    @IBOutlet weak var card: UIButton!
    @IBOutlet weak var door: UIButton!
    
    @IBOutlet weak var profile_image: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBAction func settingsClicked(_ sender: UIButton) {
        
        settings.adjustsImageWhenHighlighted = false
        
        if settings.currentImage == #imageLiteral(resourceName: "blackSettings"){
            UIView.animate(withDuration: 0.3, animations: {
                self.uploadImage.alpha = 1
                self.profile.alpha = 1
                self.card.alpha = 1
                self.door.alpha = 1
                
                self.uploadImage.center = self.uploadImageButtonCenter
                self.profile.center = self.profileButtonCenter
                self.card.center = self.cardButtonCenter
                self.door.center = self.doorButtonCenter
            })
            
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.uploadImage.alpha = 0
                self.profile.alpha = 0
                self.card.alpha = 0
                self.door.alpha = 0
                
                self.uploadImage.center = self.settings.center
                self.profile.center = self.settings.center
                self.card.center = self.settings.center
                self.door.center = self.settings.center
            })
            
        }
        if sender.currentImage == #imageLiteral(resourceName: "blackSettings") {
            sender.setImage(#imageLiteral(resourceName: "greySettings"), for: .normal)
        } else {
            sender.setImage(#imageLiteral(resourceName: "blackSettings"), for: .normal)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser?.uid == nil{
            logout()
        }
        setupProfile()
        
        uploadImageButtonCenter = uploadImage.center
        profileButtonCenter = profile.center
        cardButtonCenter = card.center
        doorButtonCenter = door.center
        
    }
    //actions
    @IBAction func uploadImageButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func profilePressed(_ sender: Any) {
        goToProfile()
    }
    
    @IBAction func doorPressed(_ sender: Any) {
        TouchIDCall()
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        TouchIDCall()
        
    }
    @IBAction func updateProfile(_ sender: Any) {
        saveChanges()
    }
    
    @IBAction func cardPressed(_ sender: Any) {
        goToCardDetails()
    }
    
    
    func TouchIDCall(){
        let authContext : LAContext = LAContext()
        var error : NSError?
        
        if authContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &error){
            
            authContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: "Confirm Logout?", reply: {
                (wasSuccesful : Bool, error : Error?) in
                
                if wasSuccesful{
                    self.logout()
                } else{
                    NSLog("NO")
                }
            })
            
        } else {
            
        }
    }
        
    //func
    func setupProfile(){
        let databaseRef = Database.database().reference()
        
        
//        profile_image.layer.cornerRadius = profile_image.frame.size.width/2
        profile_image.clipsToBounds = true
        if let uid = Auth.auth().currentUser?.uid{
            databaseRef.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject]
                {
                    self.usernameLabel.text = dict["username"] as? String
                    if let profileImageURL = dict["pic"] as? String
                    {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                            if error != nil{
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                self.profile_image?.image = UIImage(data: data!)
                            }
                        }).resume()
                    }
                }
            })
            
        }
    }
    func logout(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LoginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        present(LoginVC, animated: true, completion: nil)
    }
    
    func goToProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SettingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC")
        present(SettingsVC, animated: true, completion: nil)
    }
    
    func goToCardDetails(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CardDetailsVC = storyboard.instantiateViewController(withIdentifier: "CardDetailsVC")
        present(CardDetailsVC, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
            profile_image.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveChanges(){
        let storageRef = Storage.storage().reference()
        
        let imageName = NSUUID().uuidString
        
        let storedImage = storageRef.child("profile_images").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(self.profile_image.image!)
        {
            storedImage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString{
                        self.databaseRef.child("users").child((Auth.auth().currentUser?.uid)!).updateChildValues(["pic" : urlText], withCompletionBlock: { (error, ref) in
                            if error != nil{
                                print(error!)
                                return
                            }
                        })                    }
                })
            })
        }
    }
}

