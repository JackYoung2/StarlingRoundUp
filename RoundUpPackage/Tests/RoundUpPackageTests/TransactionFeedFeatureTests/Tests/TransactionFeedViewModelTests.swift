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
@testable import TransactionFeedFeature
import RxTest
import SharedModel
import RoundUpClient

class TransactionFeedViewModelTests: XCTestCase {
    
    var viewModel: TransactionFeedViewModelProtocol!
    var apiClient: APIClientProtocol!
    var disposeBag: DisposeBag!
    
    func setUpApiHappyPath(
        callEndpointExpectation: XCTestExpectation? = nil,
        returnValue: Any? = nil
    ) {
        apiClient = MockApiClientHappyPath(
            callEndpointExpectation: callEndpointExpectation,
            returnValue: returnValue ?? ""
        )
    }
    
    func setUpApiFailure(_ error: APIError = .networkError) {
        apiClient = MockApiClientFailure(error: error)
    }
    
    func setUpViewModel() {
        viewModel = TransactionFeedViewModel(
            apiClient: apiClient,
            route: nil,
            roundUpClient: RoundUpClient()
        )
    }
    
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        apiClient = nil
        disposeBag = nil
    }
    
    func test_roundButtonTapped_navigatesToSavingsGoalListVC() {
        setUpApiHappyPath()
        setUpViewModel()
        
        viewModel.roundButtonTapped()
        
        XCTAssertEqual(
            viewModel.route.value,
            TransactionFeedViewModel.Route.savingsGoal(
                .init(
                    apiClient: apiClient,
                    account: .mock(),
                    roundUpAmount: .init(currency: .validCurrency, minorUnits: 152)
                )
            )
        )
    }
    
    func test_getSavingsGoals_publishes_result() async throws {
        setUpApiHappyPath(returnValue: TransactionFeedItemResponse.mock)
        setUpViewModel()
        viewModel.accountRelay.accept(.mock())
        try await viewModel.fetchTransactions()
        
        XCTAssertEqual(
            viewModel.transactions.value,
            dummyTransactions,
            "Successful results should be published"
        )
    }
    
    func test_getAccount_publishes_result() async throws {
        setUpApiHappyPath(returnValue: AccountResponse.mock(accountId: UUID.mock))
        setUpViewModel()
        viewModel.accountRelay.accept(Account.mock(accountUid: UUID.mock))
        try await viewModel.fetchAccount()
        
        XCTAssertEqual(
            viewModel.accountRelay.value,
            Account.mock(accountUid: UUID.mock),
            "Successful results should be published"
        )
    }
}
