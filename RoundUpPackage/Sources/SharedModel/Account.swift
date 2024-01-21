//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation

public struct AccountResponse: Codable {
    public let accounts: [Account]
}

public struct Account: Codable, Equatable {
    public let accountUid: String
    public let accountType: String
    public let defaultCategory: String
    public let currency: String
    public let createdAt: String
    public let name: String
}

