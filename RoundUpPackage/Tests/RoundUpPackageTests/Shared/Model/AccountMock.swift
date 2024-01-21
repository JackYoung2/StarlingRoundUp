//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation
@testable import SharedModel

extension Account {
    static func mock(
        accountUid: UUID = UUID.mock,
        accountType: String = "PRIMARY",
        defaultCategory: UUID = UUID.mock,
        currency: String = "GBP",
        createdAt: String = "2024-01-18T13:09:36.054Z",
        name: String = "Personal"
    ) -> Account {
            Account(
                accountUid: accountUid.uuidString,
                accountType: "PRIMARY",
                defaultCategory: defaultCategory.uuidString,
                currency: "GBP",
                createdAt: "2024-01-18T13:09:36.054Z",
                name: "Personal"
            )
    }
}


extension AccountResponse {
    static func mock(accountId: UUID? = nil) -> AccountResponse {
        return AccountResponse(accounts: [
            Account.mock(accountUid: accountId ?? UUID())
        ])
    }
}
