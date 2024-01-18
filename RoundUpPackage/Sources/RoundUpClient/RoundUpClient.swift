//
//  File.swift
//  
//
//  Created by Jack Young on 14/01/2024.
//

import Foundation

public protocol RoundUpClientProtocol {
    
}

public struct RoundUpClient: RoundUpClientProtocol {
    
    public init(){}
    
    public func roundUpSpend(_ transactionAmmount: Decimal) -> Decimal {
        let ammount = NSDecimalNumber(decimal: transactionAmmount).doubleValue
        let difference = (ceil(ammount) - ammount)
        let trim = Double(round(1000 * difference) / 1000)
        let decimal = Decimal(trim)
        return decimal
    }
}
