//
//  File.swift
//
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation

extension CreateSavingsGoalViewModel.Route: Equatable {
    public static func == (
        lhs: CreateSavingsGoalViewModel.Route,
        rhs: CreateSavingsGoalViewModel.Route
    ) -> Bool {
        switch (lhs, rhs) {
        case let (.alert(lhs), .alert(rhs)):
            return lhs == rhs
        }
    }
    
    
}
