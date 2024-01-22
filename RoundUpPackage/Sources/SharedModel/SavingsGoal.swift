//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation

public struct SavingsGoalListResponse: Codable {
    public let savingsGoalList: [SavingsGoal]
}

public struct CreateSavingsGoalResponse: Codable, Equatable {
    public let savingsGoalUid: String
    public let success: Bool
    
    public init(savingsGoalUid: String, success: Bool) {
        self.savingsGoalUid = savingsGoalUid
        self.success = success
    }
}

public struct SavingsGoalTransferResponse: Codable {
    public let transferUid: String
    public let success: Bool
    
    public init(transferUid: String, success: Bool) {
        self.transferUid = transferUid
        self.success = success
    }
}

public struct SavingsGoal: Codable, Equatable {
    public let savingsGoalUid: String
    public let name: String
    public let target: Amount
    public let totalSaved: Amount
    public let savedPercentage: Double
    public let state: String
    
    public init(
        savingsGoalUid: String,
        name: String,
        target: Amount,
        totalSaved: Amount,
        savedPercentage: Double,
        state: String
    ) {
        self.savingsGoalUid = savingsGoalUid
        self.name = name
        self.target = target
        self.totalSaved = totalSaved
        self.savedPercentage = savedPercentage
        self.state = state
    }
}

public struct SavingsGoalRequestBody: Codable, Equatable {
    public let name: String
    public let currency: String
    public let target: Amount
//    public let base64EncodedPhoto: String
    
    public init(name: String, currency: String, target: Amount ) {
        self.name = name
        self.currency = currency
        self.target = target
//        self.base64EncodedPhoto = ""
    }
}

public struct TopUpRequest: Codable {
    public let amount: Amount
    
    public init(amount: Amount) {
        self.amount = amount
    }
}
