//
//  String+Numeric.swift
//  imagepicker
//
//  Created by Eoghan Casey on 19/12/2017.
//  Copyright © 2017 Eoghan Casey. All rights reserved.
//

import Foundation

extension String {
    func isNumericString() -> Bool {
        
        let nonDigitChars = CharacterSet.decimalDigits.inverted
        
        let string = self as NSString
        
        if string.rangeOfCharacter(from: nonDigitChars).location == NSNotFound {
            // definitely numeric entierly
            return true
        }
        
        return false
    }
}
