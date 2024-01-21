//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation

public extension Result {
    var error: Error? {
        if case let .failure(failure) = self {
            return failure
        }
        
        return nil
    }
}
