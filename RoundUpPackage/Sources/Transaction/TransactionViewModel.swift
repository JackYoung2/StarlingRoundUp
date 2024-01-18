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
    
//    var transactionDisplay: String {
//        "\(transaction.amount.asCurrencyString ?? "")"
//    }
//    
//    var timeDisplay: String {
//        "\(transaction.date.asTimeString ?? "")"
//    }
    
    var roundedUpAmount: Decimal {
        0.0
//        roundUpClient.roundUpSpend(transaction.amount)
    }
    
    var roundedUpDisplay: String {
        "+\(roundedUpAmount.asCurrencyString ?? "")"
    }
    
    public init(transaction: Transaction) {
        self.transaction = transaction
    }
}
