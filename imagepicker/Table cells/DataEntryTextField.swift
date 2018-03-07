//
//  DateEntryTextField.swift
//  imagepicker
//
//  Created by Eoghan Casey on 19/12/2017.
//  Copyright © 2017 Eoghan Casey. All rights reserved.
//

import UIKit

class DataEntryTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    func setDoneInputAccessoryView() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44))
        
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(DataEntryTextField.btnDoneTap(_:)))

        
        toolbar.setItems([space, doneButton], animated: true)
        
        self.inputAccessoryView = toolbar
        
    }
    
    func btnDoneTap(_ sender: AnyObject) {
        resignFirstResponder()
    }

}
