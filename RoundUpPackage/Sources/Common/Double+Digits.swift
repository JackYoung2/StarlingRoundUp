//
//  File.swift
//  
//
//  Created by Jack Young on 20/01/2024.
//

import Foundation

public extension Double {
    var digits: Int {
        var count = 0
        var num = self
        while num != 0 {
            count += 1
            num /= 10
        }
        return count
    }
}
