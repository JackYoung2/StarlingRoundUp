//
//  File.swift
//
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation
import SharedModel
import Common

@dynamicMemberLookup
public class SavingsGoalViewModel {
    
    var savingsGoal: SavingsGoal
    
    public init(savingsGoal: SavingsGoal) {
        self.savingsGoal = savingsGoal
    }
    
    public var displayedProgress: Float { Float(savingsGoal.savedPercentage / 100) }
    
    public var displayedTarget: String { ""
//        savingsGoal.totalSaved.minorUnits.asCurrencyString ?? ""
    }
    
    public var displayedCurrentAmount: String { ""
//        savingsGoal.target.minorUnits.asCurrencyString ?? ""
    }
    
    public subscript<T>(dynamicMember keyPath: KeyPath<SavingsGoal, T>) -> T {
        return savingsGoal[keyPath: keyPath]
    }
    
}
