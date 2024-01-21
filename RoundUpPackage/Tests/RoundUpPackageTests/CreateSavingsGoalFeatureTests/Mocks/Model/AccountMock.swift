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
        accountUid: UUID = UUID(),
        accountType: String = "PRIMARY",
        defaultCategory: UUID = UUID(),
        currency: String = "GBP",
        createdAt: String = "2024-01-18T13:09:36.054Z",
        name: String = "Personal"
    ) -> Account {
            Account(
                accountUid: accountUid.uuidString,
                accountType: "PRIMARY",
                defaultCategory: accountUid.uuidString,
                currency: "GBP",
                createdAt: "2024-01-18T13:09:36.054Z",
                name: "Personal"
            )
    }
}


extension AccountResponse {
    static var mock: AccountResponse {
        return AccountResponse(accounts: [
            Account(
                accountUid: "c0957db4-4587-4c91-96ec-787f45e3c5cd",
                accountType: "PRIMARY",
                defaultCategory: "c0957180-0474-43f7-a5c4-17dd6fc9dd77",
                currency: "GBP",
                createdAt: "2024-01-18T13:09:36.054Z",
                name: "Personal"
            )
        ])
    }
}
