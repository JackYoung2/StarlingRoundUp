//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation
import APIClient

extension Endpoint {
    static func getFeed(
        for accountId: String,
        in categoryId: String,
        since formattedDate: String    
    ) -> Self {
        Self.init(
            path: "/api/v2/feed/account/\(accountId)/category/\(categoryId)",
            queryItems: [
                .init(name: "changesSince", value: formattedDate)
            ],
            method: .get
        )
    }
    
}
