//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation
import XCTest
@testable import RoundUpClient
import SharedModel

class RoundUpClientTests: XCTestCase {
    func testRoundUpSpend() {
        let values = [
            Amount(currency: "GBP", minorUnits: 1),
            Amount(currency: "GBP", minorUnits: 2),
            Amount(currency: "GBP", minorUnits: 3),
            Amount(currency: "GBP", minorUnits: 4),
            Amount(currency: "GBP", minorUnits: 5),
            Amount(currency: "GBP", minorUnits: 6),
            Amount(currency: "GBP", minorUnits: 7),
            Amount(currency: "GBP", minorUnits: 8),
            Amount(currency: "GBP", minorUnits: 9),
            Amount(currency: "GBP", minorUnits: 10),
            Amount(currency: "GBP", minorUnits: 11),
            Amount(currency: "GBP", minorUnits: 12),
            Amount(currency: "GBP", minorUnits: 13),
            Amount(currency: "GBP", minorUnits: 14),
            Amount(currency: "GBP", minorUnits: 15),
            Amount(currency: "GBP", minorUnits: 100),
        ]
        
        let expected = [
            99,98,97,96,95,94,93,92,91,90,89,88,87,86,85, 0
        ]
        
        let rounded = values.map {
            RoundUpClient().roundUpSpend(code: $0.currency, $0.minorUnits)
        }
        
        XCTAssertEqual(rounded, expected)
        
        print(rounded)
    }
    
}

