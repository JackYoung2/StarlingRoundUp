//
//  File.swift
//
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation
import SharedModel
import Common

public protocol SavingsGoalViewModelProtocol {
    var displayedProgress: Float { get }
    var displayedTarget: String { get }
    var displayedCurrentAmount: String { get }
    subscript<T>(dynamicMember keyPath: KeyPath<SavingsGoal, T>) -> T { get }
}

@dynamicMemberLookup
public class SavingsGoalViewModel: SavingsGoalViewModelProtocol {
    
    var savingsGoal: SavingsGoal
    
    public init(savingsGoal: SavingsGoal) {
        self.savingsGoal = savingsGoal
    }
    
    public var displayedProgress: Float { Float(savingsGoal.savedPercentage / 100) }
    
    public var displayedTarget: String {
        NumberFormatter.formattedCurrencyFrom(code: savingsGoal.target.currency, amount: savingsGoal.target.minorUnits) ?? ""
    }
    
    public var displayedCurrentAmount: String {
        NumberFormatter.formattedCurrencyFrom(code: savingsGoal.totalSaved.currency, amount: savingsGoal.totalSaved.minorUnits) ?? ""
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<SavingsGoal, T>) -> T {
        return savingsGoal[keyPath: keyPath]
    }
    
}
