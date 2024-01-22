//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation
import APIClient
import SharedModel

public extension Endpoint<AccountResponse> {
    static func getAccount() -> Self {
        Self.init(
            path: "/api/v2/accounts",
            method: .get
        )
    }
    
    
}
