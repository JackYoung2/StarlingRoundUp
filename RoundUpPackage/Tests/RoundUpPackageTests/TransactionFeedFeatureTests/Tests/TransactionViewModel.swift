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
