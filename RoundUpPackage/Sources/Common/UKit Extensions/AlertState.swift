//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import UIKit
import SharedModel

public struct AlertState {
    public var title: String
    public var message: String

    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}

public enum AlertType {
    case emptyName,
         noAccount,
         targetTooLow,
         genericError,
         network,
         confirmAddToGoal(String, SavingsGoal),
         savingsAddedSuccesfully(String, String),
         createGoalSuccess(String)
    
    public var alertState: AlertState {
        switch self {
        case .emptyName:
            return .emptyName
        case .noAccount:
            return .noAccount
        case .targetTooLow:
            return .targetTooLow
        case .genericError:
            return .genericError
        case .network:
            return .network
        case let .confirmAddToGoal(amount, goal):
            return .confirmAddToSavingsGoal(amount, goalName: goal.name)
        case let .savingsAddedSuccesfully(amount, goal):
            return .savingsAddedSuccesfully(amount, goalName: goal)
        case let .createGoalSuccess(name):
            return .goalAddedSuccesfully(name)
        
        }
    }
}

public extension AlertState {
    static let emptyName = Self.init(title: "Name Missing", message: "Please choose a name for your savings goal")
    static let targetTooLow = Self.init(title: "Target Too Low", message: "Target amount is currently 0. Let's aim a little higher!")
    static let genericError = Self.init(title: "Unable To Complete Operation", message: "An unknown error occured")
    static let network = Self.init(title: "Unable To Create Savings Goal", message: "Please check your connection and try again")
    static let noAccount = Self.init(title: "No account selected", message: "Please choose an account")
    
    static func confirmAddToSavingsGoal(_ amountString: String, goalName: String) -> Self {
        Self.init(
            title: "Add \(amountString) Savings Goal?",
            message: "Are you sure you want to add \(amountString) to \(goalName)?"
        )
    }
    
    static func savingsAddedSuccesfully(_ amountString: String, goalName: String) -> Self {
        Self.init(
            title: "Success",
            message: "Added \(amountString) to \(goalName)!"
        )
    }
    
    static func goalAddedSuccesfully(_ goalName: String) -> Self {
        Self.init(
            title: "Success",
            message: "\(goalName) created successfully!"
        )
    }
}
