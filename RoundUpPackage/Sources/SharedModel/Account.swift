//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation

struct AccountResponse: Codable {
    let accounts: [Account]
}

struct Account: Codable {
    let accountUid: String
    let accountType: String
    let defaultCategory: String
    let currency: String
    let createdAt: String
    let name: String

//    enum CodingKeys: String, CodingKey {
//        case accountUid
//        case accountType
//        case defaultCategory
//        case currency
//        case createdAt
//        case name
//    }
}

