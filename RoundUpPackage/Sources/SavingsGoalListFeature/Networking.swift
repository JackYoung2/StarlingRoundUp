//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import APIClient
import SharedModel
import Foundation

extension Endpoint {
    static func getSavingsGoals(for account: String) -> Self {
        .init(
            path: "/api/v2/account/\(account)/savings-goals",
            method: .get
        )
    }
    
    static func add(
        _ amount: Data,
        to savingsGoalId: String,
        for account: String,
        with uuid: String
    ) -> Self {
        .init(
            path: "/api/v2/account/\(account)/savings-goals/\(savingsGoalId)/add-money/\(uuid)",
            method: .put,
            body: amount
        )
    }
}
