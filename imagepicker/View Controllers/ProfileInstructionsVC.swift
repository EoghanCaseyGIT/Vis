//
//  ProfileInstructionsVC.swift
//  imagepicker
//
//  Created by Eoghan Casey on 07/03/2018.
//  Copyright © 2018 Eoghan Casey. All rights reserved.
//

import Foundation
import UIKit

class ProfileInstructionsVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    @IBAction func finishPressed(_ sender: Any) {
        skipInstructions()
    }
    
    
    func skipInstructions(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MyTabBar = storyboard.instantiateViewController(withIdentifier: "myTabBar")
        present(MyTabBar, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
