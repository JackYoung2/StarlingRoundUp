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

public struct SavingsGoal: Codable {
    public let savingsGoalUid: String
    public let name: String
    public let target: Amount
    public let totalSaved: Amount?
    public let savedPercentage: Double?
    public let state: String?
    
    public init(
        savingsGoalUid: String,
        name: String,
        target: Amount,
        totalSaved: Amount? = nil,
        savedPercentage: Double? = nil,
        state: String? = nil
    ) {
        self.savingsGoalUid = savingsGoalUid
        self.name = name
        self.target = target
        self.totalSaved = totalSaved
        self.savedPercentage = savedPercentage
        self.state = state
    }

//    enum CodingKeys: String, CodingKey {
//        case savingsGoalUid
//        case name
//        case target
//        case totalSaved
//        case savedPercentage
//        case state
//    }
}
