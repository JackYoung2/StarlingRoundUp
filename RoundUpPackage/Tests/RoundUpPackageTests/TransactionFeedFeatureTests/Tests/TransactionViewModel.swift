//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation
import XCTest
@testable import TransactionFeedFeature
import SharedModel

class TransactionViewModelTests: XCTestCase {

    func testComputeRoundUpDisplay() async throws {
        var viewModel = TransactionViewModel(transaction: dummyTransactions[1])
        
        XCTAssertEqual(viewModel.computeRoundUpDisplay(), "£0.97")
    }
}

//
//Transaction(
//    feedItemUid: "1",
//    categoryUid: "category1",
//    amount: Amount(currency: "GBP", minorUnits: 1000),
//    sourceAmount: Amount(currency: "GBP", minorUnits: 1000),
//    direction: .in,
//    updatedAt: dateFormatter.date(from: "2023-05-15T08:30:00Z")!,
//    transactionTime: dateFormatter.date(from: "2023-05-14T12:45:00Z")!,
//    settlementTime: dateFormatter.date(from: "2023-05-14T15:20:00Z")!,
//    status: .settled,
//    counterPartyName: "Counterparty 1",
//    country: "GB",
//    spendingCategory: "Food"
//)
