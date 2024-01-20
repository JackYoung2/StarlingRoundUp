//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import APIClient

extension Endpoint {
    static func getSavingsGoals(for account: String) -> Self {
        .init(
            path: "/api/v2/account/\(account)/savings-goals",
            method: .get
        )
    }
    
//    static func add(_ minorUnits: Int, to account: String) -> Self {
//        .init(
//            path: "/api/v2/account/\(account)/savings-goals",
//            method: .get
//        )
//    }
}
