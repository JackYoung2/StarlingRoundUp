//
//  File.swift
//
//
//  Created by Jack Young on 09/01/2024.
//

import Foundation

public enum SettlementStatus: String, Codable {
    case settled = "SETTLED"
}

public enum Direction: String, Codable {
    case `in` = "IN", out = "OUT"
}

public struct TransactionFeedItemResponse: Codable {
    public var feedItems: [Transaction]
}

public struct Transaction: Codable, Equatable {
    public let feedItemUid: String
    public let categoryUid: String
    public let amount: Amount
    public let sourceAmount: Amount
    public let direction: Direction
    public let updatedAt: Date
    public let transactionTime: Date
    public let settlementTime: Date
    public let status: SettlementStatus
    public let counterPartyName: String
    public let country: String
    public let spendingCategory: String
    
    public init(
        feedItemUid: String,
        categoryUid: String,
        amount: Amount,
        sourceAmount: Amount,
        direction: Direction,
        updatedAt: Date,
        transactionTime: Date,
        settlementTime: Date,
        status: SettlementStatus,
        counterPartyName: String,
        country: String,
        spendingCategory: String
    ) {
        self.feedItemUid = feedItemUid
        self.categoryUid = categoryUid
        self.amount = amount
        self.sourceAmount = sourceAmount
        self.direction = direction
        self.updatedAt = updatedAt
        self.transactionTime = transactionTime
        self.settlementTime = settlementTime
        self.status = status
        self.counterPartyName = counterPartyName
        self.country = country
        self.spendingCategory = spendingCategory
    }
}
