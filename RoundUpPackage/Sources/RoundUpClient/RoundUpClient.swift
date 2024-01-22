//
//  File.swift
//  
//
//  Created by Jack Young on 14/01/2024.
//

import Foundation
import Common

public protocol RoundUpClientProtocol {
    func roundUpSpend(code: String, _ transactionAmount: Int) -> Int
}

public struct RoundUpClient: RoundUpClientProtocol {
    public init() {}
    
    public func roundUpSpend(code: String, _ transactionAmount: Int) -> Int {
        let decimalPlaces = NumberFormatter.currencyFormatter(for: code).maximumFractionDigits
        let digits = transactionAmount.digits
        
        switch digits {
        case 1:
            let dub = pow(Double(10), Double(decimalPlaces)) - Double(transactionAmount)
            return Int(dub)
        default:
            let tens = transactionAmount.digit(atPosition: transactionAmount.digits - 2)
            let ones = transactionAmount.digit(atPosition: transactionAmount.digits - 1)
            guard let ones, let tens else { return 0 }
            if tens == 0 && ones == 0 { return 0 }
            
            let subtrahend = pow(Double(10), Double(decimalPlaces))
            let minuend = Double(tens * 10 + ones)
            let difference = subtrahend - minuend
            
            return Int(difference)
        }
    }  
}
