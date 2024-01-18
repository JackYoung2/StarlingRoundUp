//
//  File.swift
//  
//
//  Created by Jack Young on 11/01/2024.
//

import Foundation
import SharedModel
import RoundUpClient

public struct TransactionViewModel {
    
//    TODO: - Abstract
    var roundUpClient: RoundUpClient = .init()
    var transaction: Transaction
    
    var transactionDisplay: String {
       NumberFormatter.formattedCurrencyFrom(code: transaction.amount.currency, amount: transaction.amount.minorUnits) ?? ""
    }
//    
    var timeDisplay: String {
        "\(transaction.settlementTime.asTimeString ?? "")"
    }
    
//    var roundedUpAmount: Decimal {
//        roundUpClient.roundUpSpend(code: transaction.amount.currency, transaction.amount.minorUnits)
//    }
    
    var roundedUpDisplay: String {
        let differenceInMinorUnits = roundUpClient.roundUpSpend(code: transaction.amount.currency, transaction.amount.minorUnits)
        let displayValue = NumberFormatter.formattedCurrencyFrom(code: transaction.amount.currency, amount: differenceInMinorUnits) ?? ""
        
        return "+\(displayValue)"
    }
    
    public init(transaction: Transaction) {
        self.transaction = transaction
    }
}
