//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import APIClient
import Foundation

extension Endpoint {
    static func createSavingsGoal(for account: String) -> Self {
        .init(
            path: "/account/\(account)/savings-goals",
            method: .put
        )
    }
}

//https://api-sandbox.starlingbank.com/api/v2/account/c0957db4-4587-4c91-96ec-787f45e3c5cd/savings-goals
