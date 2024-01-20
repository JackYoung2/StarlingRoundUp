//
//  File.swift
//  
//
//  Created by Jack Young on 20/01/2024.
//

import Foundation

public extension Result {
    var success: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var failure: Bool {
        !success
    }
}
