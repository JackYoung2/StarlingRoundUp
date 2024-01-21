//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation
@testable import SharedModel

public extension TransactionFeedItemResponse {
    static let mock = Self.init(feedItems: dummyTransactions)
}

public let dummyTransactions: [Transaction] = [
    Transaction(
        feedItemUid: "1",
        categoryUid: "category1",
        amount: Amount(currency: "GBP", minorUnits: 1000),
        sourceAmount: Amount(currency: "GBP", minorUnits: 1000),
        direction: .in,
        updatedAt: dateFormatter.date(from: "2023-05-15T08:30:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-14T12:45:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-14T15:20:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 1",
        country: "GB",
        spendingCategory: "Food"
    ),
    Transaction(
        feedItemUid: "2",
        categoryUid: "category2",
        amount: Amount(currency: "GBP", minorUnits: 503),
        sourceAmount: Amount(currency: "GBP", minorUnits: 503),
        direction: .out,
        updatedAt: dateFormatter.date(from: "2023-05-13T09:15:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-12T18:30:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-13T10:45:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 2",
        country: "GB",
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
        amount: Amount(currency: "GBP", minorUnits: 1211),
        sourceAmount: Amount(currency: "GBP", minorUnits: 1211),
        direction: .out,
        updatedAt: dateFormatter.date(from: "2023-05-10T11:30:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-09T14:20:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-10T12:45:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 4",
        country: "GB",
        spendingCategory: "Entertainment"
    ),
    Transaction(
        feedItemUid: "5",
        categoryUid: "category5",
        amount: Amount(currency: "GBP", minorUnits: 900),
        sourceAmount: Amount(currency: "GBP", minorUnits: 900),
        direction: .in,
        updatedAt: dateFormatter.date(from: "2023-05-09T18:00:00Z")!,
        transactionTime: dateFormatter.date(from: "2023-05-08T21:15:00Z")!,
        settlementTime: dateFormatter.date(from: "2023-05-09T19:30:00Z")!,
        status: .settled,
        counterPartyName: "Counterparty 5",
        country: "GB",
        spendingCategory: "Health"
    ),
]


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.timeZone = TimeZone(identifier: "UTC")
    return formatter
}()
