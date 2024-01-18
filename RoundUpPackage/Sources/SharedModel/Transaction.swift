//
//  File.swift
//
//
//  Created by Jack Young on 09/01/2024.
//

import Foundation

public enum SettlementStatus: String, Codable {
    case settled
}

public enum Direction: String, Codable {
    case `in`, out
}

public struct Transaction: Codable {
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

public struct Amount: Codable {
    public let currency: String
    public let minorUnits: Int
    
    public init(currency: String, minorUnits: Int) {
        self.currency = currency
        self.minorUnits = minorUnits
    }
}

//enum CodingKeys: String, CodingKey {
//        case feedItemUid
//        case categoryUid
//        case amount
//        case sourceAmount
//        case direction
//        case updatedAt
//        case transactionTime
//        case settlementTime
//        case source
//        case status
//        case transactingApplicationUserUid
//        case counterPartyType
//        case counterPartyUid
//        case counterPartyName
//        case counterPartySubEntityUid
//        case counterPartySubEntityName
//        case counterPartySubEntityIdentifier
//        case counterPartySubEntitySubIdentifier
//        case reference
//        case country
//        case spendingCategory
//        case hasAttachment
//        case hasReceipt
//        case batchPaymentDetails
//    }

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.timeZone = TimeZone(identifier: "UTC")
    return formatter
}()

public let dummyTransactions: [Transaction] = [
    Transaction(
        feedItemUid: "1",
        categoryUid: "category1",
        amount: Amount(currency: "USD", minorUnits: 1000),
        sourceAmount: Amount(currency: "USD", minorUnits: 1000),
        direction: .in,
        updatedAt: dateFormatter.date(from: "2023-05-15T08:30:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-14T12:45:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-14T15:20:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 1",
        country: "US",
        spendingCategory: "Food"
    ),
    Transaction(
        feedItemUid: "2",
        categoryUid: "category2",
        amount: Amount(currency: "EUR", minorUnits: 503),
        sourceAmount: Amount(currency: "EUR", minorUnits: 503),
        direction: .out,
        updatedAt: dateFormatter.date(from: "2023-05-13T09:15:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-12T18:30:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-13T10:45:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 2",
        country: "DE",
        spendingCategory: "Shopping"
    ),
    Transaction(
        feedItemUid: "3",
        categoryUid: "category3",
        amount: Amount(currency: "GBP", minorUnits: 750),
        sourceAmount: Amount(currency: "GBP", minorUnits: 750),
        direction: .in,
        updatedAt: dateFormatter.date(from: "2023-05-11T14:00:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-10T20:45:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-11T15:30:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 3",
        country: "GB",
        spendingCategory: "Travel"
    ),
    Transaction(
        feedItemUid: "4",
        categoryUid: "category4",
        amount: Amount(currency: "AUD", minorUnits: 1211),
        sourceAmount: Amount(currency: "AUD", minorUnits: 1211),
        direction: .out,
        updatedAt: dateFormatter.date(from: "2023-05-10T11:30:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-09T14:20:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-10T12:45:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 4",
        country: "AU",
        spendingCategory: "Entertainment"
    ),
    Transaction(
        feedItemUid: "5",
        categoryUid: "category5",
        amount: Amount(currency: "CAD", minorUnits: 900),
        sourceAmount: Amount(currency: "CAD", minorUnits: 900),
        direction: .in,
        updatedAt: dateFormatter.date(from: "2023-05-09T18:00:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-08T21:15:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-09T19:30:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 5",
        country: "CA",
        spendingCategory: "Health"
    ),
]
