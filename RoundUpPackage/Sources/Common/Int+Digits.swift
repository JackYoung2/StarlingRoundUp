//
//  File.swift
//  
//
//  Created by Jack Young on 22/01/2024.
//

import Foundation

public extension Int {
    var digits: Int {
        var count = 0
        var num = self
        while num != 0 {
            count += 1
            num /= 10
        }
        return count
    }
    
    func digit(atPosition position: Int) -> Int? {
        guard position < digits else {
            return nil
        }
        var num = self
        let correctedPosition = Double(position + 1)
        while num / Int(pow(10.0, correctedPosition)) != 0 {
            num /= 10
        }
        return num % 10
    }
}
