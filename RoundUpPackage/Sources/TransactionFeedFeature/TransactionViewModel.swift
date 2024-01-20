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
        NumberFormatter.formattedCurrencyFrom(amount: transaction.amount) ?? ""
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
        guard differenceInMinorUnits != 0 else { return "" }
        let amount = Amount(currency: transaction.amount.currency, minorUnits: differenceInMinorUnits)
        let displayValue = NumberFormatter.formattedCurrencyFrom(amount: amount) ?? ""

        return "+\(displayValue)"
    }
    
    public init(transaction: Transaction) {
        self.transaction = transaction
    }
}
