//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import RxSwift
import RxCocoa
@testable import AppFeature
@testable import CreateSavingsGoalFeature
import SharedModel
import APIClient
import XCTest

public class CreateSavingsRequestBodyPartialGoalMockViewModel: CreateSavingsGoalViewModel {
    
    var assertEqual: (SavingsGoalRequestBody, SavingsGoalRequestBody) -> Void
    
    let savingsGoalMock: SavingsGoalRequestBody
    
    init(
        account: Account,
        apiClient: APIClientProtocol,
        savingsGoalMock: SavingsGoalRequestBody,
        assertEqual: @escaping (SavingsGoalRequestBody, SavingsGoalRequestBody) -> Void
    ) {
        self.savingsGoalMock = savingsGoalMock
        self.assertEqual = assertEqual
        super.init(account: account, apiClient: apiClient, sessionManager: MockSessionManager())
    }
    
    // MARK: - Methods
    
    public override func postSavingsGoal(_ savingsGoal: SavingsGoalRequestBody) async throws {
        assertEqual(savingsGoalMock, savingsGoal)
    }
}
