//
//  Extensions.swift
//  14-ARithmetics
//
//  Created by Salvador Martí Solsona on 28/09/2019.
//  Copyright © 2019 Salvador Martí Solsona. All rights reserved.
//

import Foundation


extension Int {
    
    var hasUniqueDigits : Bool {
        
        let strValue = String(self)
        let uniqueChars = Set(strValue)
        return uniqueChars.count == strValue.count
        
    }
    
    
}
