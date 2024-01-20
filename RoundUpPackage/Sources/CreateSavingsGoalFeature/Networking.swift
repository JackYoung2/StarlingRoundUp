//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import APIClient
import Foundation
import SharedModel

public extension Endpoint {
    static func createSavingsGoal(
        for account: String,
        goal: SavingsGoalRequestBody,
        encoder: JSONEncoder = JSONEncoder()
    ) -> Self {
        .init(
            path: "/api/v2/account/\(account)/savings-goals",
            method: .put,
            body: try? encoder.encode(goal)
        )
    }
}
