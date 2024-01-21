//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation
@testable import SharedModel

extension Amount {
    static let mock = Self.init(currency: .validCurrency, minorUnits: 257)
}
