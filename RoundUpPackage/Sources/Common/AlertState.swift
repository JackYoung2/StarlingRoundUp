//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import UIKit

public struct AlertState {
    public var title: String
    public var message: String
//    public var confirmAction: UIAlertAction?
//    public var cancelAction: UIAlertAction?
    
    public init(
        title: String, 
        message: String
//        confirmAction: UIAlertAction? = nil,
//        cancelAction: UIAlertAction? = nil
    
    ) {
        self.title = title
        self.message = message
//        self.confirmAction = confirmAction
//        self.cancelAction = cancelAction
    }
}

public enum AlertType {
    case emptyName, targetTooLow, genericError, network, confirmAddToGoal(String, String), itWorked
    
    public var alertState: AlertState {
        switch self {
        case .emptyName:
            return .emptyName
        case .targetTooLow:
            return .targetTooLow
        case .genericError:
            return .genericError
        case .network:
            return .network
        case let .confirmAddToGoal(amount, goal):
            return .confirmAddToSavingsGoal(amount, goalName: goal)
        case .itWorked:
            return .resultWasASuccess
        
        }
    }
}

public extension AlertState {
    static var emptyName = Self.init(title: "Name Missing", message: "Please choose a name for your savings goal")
    static var targetTooLow = Self.init(title: "Target Too Low", message: "Target amount is currently 0. Let's aim a little higher!")
    static var genericError = Self.init(title: "Unable To Create Savings Goal", message: "An unknown error occured")
    static var network = Self.init(title: "Unable To Create Savings Goal", message: "Please check your connection and try again")
    static var resultWasASuccess = Self.init(title: "It worked", message: "Yay!")
    
    static func confirmAddToSavingsGoal(_ amountString: String, goalName: String) -> Self {
        Self.init(
            title: "Add \(amountString) Savings Goal?",
            message: "Are you sure you want to add \(amountString) to \(goalName)?"
        )
    }
}
