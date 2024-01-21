//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import XCTest
import RxSwift
@testable import AppFeature
import APIClient
@testable import SavingsGoalListFeature
import SavingsGoalFeature
import RxTest
import SharedModel

public class AddToEndpointPartialMock: SavingsGoalListViewModel {
    public override func setUpSubscribers() {}
}

public class SuccessfulGoalUpdate: SavingsGoalListViewModel {
    
    var onGetSavingsGoals: () -> ()
    
    public override func getSavingsGoals() async throws {
        onGetSavingsGoals()
    }
    
    public init(
        apiClient: APIClientProtocol,
        onGetSavingsGoals: @escaping () -> Void
    ) {
        self.onGetSavingsGoals = onGetSavingsGoals
        super.init(apiClient: apiClient, account: .mock(), roundUpAmount: .mock)
    }
}
