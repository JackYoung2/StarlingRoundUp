//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation

public struct Amount: Codable, Equatable {
    public let currency: String
    public let minorUnits: Int
    
    public init(currency: String, minorUnits: Int) {
        self.currency = currency
        self.minorUnits = minorUnits
    }
}
