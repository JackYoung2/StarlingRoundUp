//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation
@testable import SharedModel

public extension SavingsGoalListResponse {
    static let mock = Self.init(savingsGoalList: testSavingsGoals)
}

public extension SavingsGoalTransferResponse {
    static let mockSucess = Self.init(transferUid: UUID().uuidString, success: true)
}

let firstSavingsGoal = SavingsGoal(
    savingsGoalUid: "c0efc8ad-1a48-4bf3-b0c8-d2f23b370774",
    name: "Trip to Paris",
    target: Amount(currency: "GBP", minorUnits: 123456),
    totalSaved: Amount(currency: "GBP", minorUnits: 0),
    savedPercentage: 0,
    state: "ACTIVE"
)

let testSavingsGoals: [SavingsGoal] = [
    firstSavingsGoal,
    SavingsGoal(
        savingsGoalUid: "a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6",
        name: "New Laptop",
        target: Amount(currency: "USD", minorUnits: 150000),
        totalSaved: Amount(currency: "USD", minorUnits: 50000),
        savedPercentage: 33,
        state: "ACTIVE"
    ),
    SavingsGoal(
        savingsGoalUid: "x1y2z3w4-5v6-6u7-7t8-8s9r0q1p2o3n",
        name: "Emergency Fund",
        target: Amount(currency: "CAD", minorUnits: 100000),
        totalSaved: Amount(currency: "CAD", minorUnits: 25000),
        savedPercentage: 25,
        state: "ACTIVE"
    ),
    SavingsGoal(
        savingsGoalUid: "f1e2d3c4-b5a6-f7e8-d9c0-b1a2f3e4d5c6",
        name: "Dream Vacation",
        target: Amount(currency: "EUR", minorUnits: 80000),
        totalSaved: Amount(currency: "EUR", minorUnits: 20000),
        savedPercentage: 25,
        state: "ACTIVE"
    ),
    SavingsGoal(
        savingsGoalUid: "1a2b3c4d-e5f6-g7h8-i9j0-k1l2m3n4o5p6",
        name: "Home Renovation",
        target: Amount(currency: "AUD", minorUnits: 200000),
        totalSaved: Amount(currency: "AUD", minorUnits: 200000),
        savedPercentage: 100,
        state: "ACTIVE"
    )
]

