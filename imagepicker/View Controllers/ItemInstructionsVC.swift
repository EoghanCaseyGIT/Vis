//
//  ItemInstructionsVC.swift
//  imagepicker
//
//  Created by Eoghan Casey on 07/03/2018.
//  Copyright © 2018 Eoghan Casey. All rights reserved.
//

import Foundation
import UIKit


class ItemInstructionsVC: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    
    @IBAction func SkipPressed(_ sender: Any) {
        skipInstructions()
    }
    
    
    @IBAction func nextPressed(_ sender: Any) {
        nextInstructions()
    }
    
    func skipInstructions(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let MyTabBar = storyboard.instantiateViewController(withIdentifier: "myTabBar")
        present(MyTabBar, animated: true, completion: nil)
    }
    
    func nextInstructions(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ProfileInstructions = storyboard.instantiateViewController(withIdentifier: "ProfileInstructions")
        present(ProfileInstructions, animated: true, completion: nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
}
