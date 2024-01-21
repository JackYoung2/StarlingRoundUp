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
        viewModel = SavingsGoalListViewModel(
            route: nil,
            apiClient: apiClient,
            account: .mock(),
            roundUpAmount: .init(currency: .validCurrency, minorUnits: 257)
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
    
    func test_titleString() {
        setUpApiHappyPath()
        setUpViewModel()
        let expected = "Add £2.57 to Savings Goal"
        XCTAssertEqual(expected, viewModel.titleString)
    }
    
    func test_roundUpDisplayString() {
        setUpApiHappyPath()
        setUpViewModel()
        let expected = "£2.57"
        XCTAssertEqual(expected, viewModel.roundUpDisplayString)
    }
    
    func test_tappingItem_DisplaysConfirmationAlert() {
        setUpApiHappyPath()
        setUpViewModel()
        
        viewModel
            .savingsGoals
            .accept(testSavingsGoals.map(SavingsGoalViewModel.init))
        
        viewModel.didTapItem(at: IndexPath(indexes: [0,0]))
        
        XCTAssertEqual(
            viewModel.route.value,
            SavingsGoalListViewModel.Route.alert(
                .confirmAddToGoal("£2.57", firstSavingsGoal)
            ),
            "Alert should show to confirm rounding"
        )
    }
    
    func test_getSavingsGoals_publishes_result() async throws {
        setUpApiHappyPath(returnValue: SavingsGoalListResponse.mock)
        setUpViewModel()
        
        try await viewModel.getSavingsGoals()
        
        XCTAssertEqual(
            viewModel.savingsGoals.value,
            testSavingsGoals.map(SavingsGoalViewModel.init),
            "Successful results should be published"
        )
    }
    
    func test_getSavingsGoalsFailure_showsAlert() async throws {
        setUpApiFailure(.networkError)
        setUpViewModel()
        
        try await viewModel.getSavingsGoals()
        
        XCTAssertEqual(
            viewModel.route.value,
            SavingsGoalListViewModel.Route.alert(.network),
            "Alert should show to confirm rounding"
        )
        
        setUpApiFailure(.parsingError)
        viewModel = nil
        setUpViewModel()
        
        try await viewModel.getSavingsGoals()
        
        XCTAssertEqual(
            viewModel.route.value,
            SavingsGoalListViewModel.Route.alert(.genericError),
            "Alert should show to confirm rounding"
        )
    }
    
    func test_SuccesfulAddToGoal_showsAlertAndFetchesSavingsGoals() async throws {
        let fetchesSavingsGoalsExpectation = XCTestExpectation(description: "After adding to goal, updated savings goals should be fetched")
        
        setUpApiHappyPath(returnValue: SavingsGoalTransferResponse.mockSucess)
        
        viewModel = SuccessfulGoalUpdate(apiClient: apiClient) {
            fetchesSavingsGoalsExpectation.fulfill()
        }
        
        viewModel.savingsGoals.accept(testSavingsGoals.map(SavingsGoalViewModel.init))
        
        try await viewModel.addToGoal(goalId: firstSavingsGoal.savingsGoalUid)
        
        XCTAssertEqual(
            viewModel.route.value,
            SavingsGoalListViewModel.Route.alert(.savingsAddedSuccesfully("£2.57", firstSavingsGoal.name)),
            "Alert should show to confirm adding to savings goal"
        )
        await fulfillment(of: [fetchesSavingsGoalsExpectation], timeout: 1)

    }
    
    func test_AddToGoalError_showsAlert() async throws {
        setUpApiFailure(.networkError)
        setUpViewModel()
        
        try await viewModel.addToGoal(goalId: firstSavingsGoal.savingsGoalUid)
        
        XCTAssertEqual(
            viewModel.route.value,
            SavingsGoalListViewModel.Route.alert(.network),
            "Error Alert should show"
        )
        
        setUpApiFailure(.parsingError)
        viewModel = nil
        setUpViewModel()
        
        try await viewModel.getSavingsGoals()
        
        XCTAssertEqual(
            viewModel.route.value,
            SavingsGoalListViewModel.Route.alert(.genericError),
            "Alert should show to confirm rounding"
        )
    }
    
    func test_addToGoal_CallsApi() async throws {
        let apiExpectation = XCTestExpectation(description: "Should attempt api call to add to savings goal")
        setUpApiHappyPath(callEndpointExpectation: apiExpectation, returnValue: SavingsGoalTransferResponse.mockSucess)
        viewModel = AddToEndpointPartialMock(apiClient: apiClient, account: .mock(), roundUpAmount: .mock)
        try await viewModel.addToGoal(goalId: firstSavingsGoal.savingsGoalUid)
        await fulfillment(of: [apiExpectation], timeout: 1)
    }
}
