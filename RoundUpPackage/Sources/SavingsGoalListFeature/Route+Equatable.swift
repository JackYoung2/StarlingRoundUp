//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation

extension SavingsGoalListViewModel.Route: Equatable {
    public static func == (
        lhs: SavingsGoalListViewModel.Route,
        rhs: SavingsGoalListViewModel.Route
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.alert(lhs), .alert(rhs)):
            return lhs == rhs
            
        case (.createSavingsGoal, .createSavingsGoal):
            return true
            
        default:
            return false
        }
    }
    
    
}
