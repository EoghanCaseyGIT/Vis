//
//  SettingsVC.swift
//  imagepicker
//
//  Created by Eoghan Casey on 15/01/2018.
//  Copyright © 2018 Eoghan Casey. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    @IBAction func goBackPressed(_ sender: Any) {
        goBackToProfile()
    }
    
    
    func goBackToProfile(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myTabBar = storyboard.instantiateViewController(withIdentifier: "myTabBar")
        present(myTabBar, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
