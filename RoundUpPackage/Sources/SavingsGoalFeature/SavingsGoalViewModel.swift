//
//  File.swift
//
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation
import SharedModel
import Common
import RxSwift
import RxCocoa

public protocol SavingsGoalViewModelProtocol {
    var displayedProgress: Float { get }
    var displayedTarget: String { get }
    var displayedCurrentAmount: String { get }
}

@dynamicMemberLookup
public class SavingsGoalViewModel: SavingsGoalViewModelProtocol {
    public var savingsGoal: SavingsGoal
    
    public init(savingsGoal: SavingsGoal) {
        self.savingsGoal = savingsGoal
    }
    
    public var displayedProgress: Float { Float(savingsGoal.savedPercentage / 100) }
    
    public var displayedTarget: String {
        NumberFormatter.formattedCurrencyFrom(amount: savingsGoal.target) ?? ""
    }
    
    public var displayedCurrentAmount: String {
        NumberFormatter.formattedCurrencyFrom(amount: savingsGoal.totalSaved) ?? ""
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<SavingsGoal, T>) -> T {
        return savingsGoal[keyPath: keyPath]
    }
    
}
