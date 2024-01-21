//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation

extension TransactionFeedViewModel.Route: Equatable {
    public static func == (
        lhs: TransactionFeedViewModel.Route,
        rhs: TransactionFeedViewModel.Route
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.alert(lhs), .alert(rhs)):
            return lhs == rhs
            
        case (.savingsGoal, .savingsGoal):
            return lhs == rhs
            
        default:
            return false
        }
    }
}
