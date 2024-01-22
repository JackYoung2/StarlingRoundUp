//
//  File.swift
//  
//
//  Created by Jack Young on 22/01/2024.
//

import Foundation

struct ErrorResponse: Decodable {
    let error: StarlingApiErrors
    let errorDescription: String
    
    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}

enum StarlingApiErrors: String, Decodable {
    case invalidToken = "invalid_token"
}
