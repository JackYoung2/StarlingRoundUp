//
//  File.swift
//  
//
//  Created by Jack Young on 09/01/2024.
//

import Foundation

//{
//           "feedItemUid": "c096be0a-875a-4360-9f39-1be79eb3782f",
//           "categoryUid": "c0957180-0474-43f7-a5c4-17dd6fc9dd77",
//           "amount": {
//               "currency": "GBP",
//               "minorUnits": 1590
//           },
//           "sourceAmount": {
//               "currency": "GBP",
//               "minorUnits": 1590
//           },
//           "direction": "OUT",
//           "updatedAt": "2024-01-18T13:10:04.025Z",
//           "transactionTime": "2024-01-18T13:10:03.119Z",
//           "settlementTime": "2024-01-18T13:10:03.946Z",
//           "source": "FASTER_PAYMENTS_OUT",
//           "status": "SETTLED",
//           "transactingApplicationUserUid": "c0952dc8-06cd-422f-9577-14c44bde7991",
//           "counterPartyType": "PAYEE",
//           "counterPartyUid": "c096f651-16d6-4f12-9f0c-42bac03c0d83",
//           "counterPartyName": "Mickey Mouse",
//           "counterPartySubEntityUid": "c096b97d-4cac-4ea5-92f6-99f90fe2ff91",
//           "counterPartySubEntityName": "UK account",
//           "counterPartySubEntityIdentifier": "204514",
//           "counterPartySubEntitySubIdentifier": "00000825",
//           "reference": "External Payment",
//           "country": "GB",
//           "spendingCategory": "PAYMENTS",
//           "hasAttachment": false,
//           "hasReceipt": false,
//           "batchPaymentDetails": null
//       },

//public struct Transaction {
//    public var amount: Amount
//    public var category: String
//    public var merchant: String
//    public var date: Date
//    
//    public init(
//        amount: Decimal,
//        category: String,
//        merchant: String,
//        date: Date
//    ) {
//        self.amount = amount
//        self.category = category
//        self.merchant = merchant
//        self.date = date
//    }
//}


public struct Transaction: Codable {
    let feedItemUid: String
    let categoryUid: String
    let amount: Amount
    let sourceAmount: Amount
    let direction: String
    let updatedAt: String
    let transactionTime: String
    let settlementTime: String
    let source: String
    let status: String
    let transactingApplicationUserUid: String
    let counterPartyType: String
    let counterPartyUid: String
    let counterPartyName: String
    let counterPartySubEntityUid: String
    let counterPartySubEntityName: String
    let counterPartySubEntityIdentifier: String
    let counterPartySubEntitySubIdentifier: String
    let reference: String
    let country: String
    let spendingCategory: String
    let hasAttachment: Bool
    let hasReceipt: Bool
}

public struct Amount: Codable {
    let currency: String
    let minorUnits: Int
    
    public init(currency: String, minorUnits: Int) {
        self.currency = currency
        self.minorUnits = minorUnits
    }
}

//enum CodingKeys: String, CodingKey {
//        case feedItemUid
//        case categoryUid
//        case amount
//        case sourceAmount
//        case direction
//        case updatedAt
//        case transactionTime
//        case settlementTime
//        case source
//        case status
//        case transactingApplicationUserUid
//        case counterPartyType
//        case counterPartyUid
//        case counterPartyName
//        case counterPartySubEntityUid
//        case counterPartySubEntityName
//        case counterPartySubEntityIdentifier
//        case counterPartySubEntitySubIdentifier
//        case reference
//        case country
//        case spendingCategory
//        case hasAttachment
//        case hasReceipt
//        case batchPaymentDetails
//    }
