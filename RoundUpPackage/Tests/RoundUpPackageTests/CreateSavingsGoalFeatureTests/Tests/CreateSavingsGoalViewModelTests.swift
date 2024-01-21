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
@testable import CreateSavingsGoalFeature
import RxTest
import SharedModel

class CreateSavingsGoalViewModelTests: XCTestCase {
    
    var scheduler: TestScheduler!
    var viewModel: CreateSavingsGoalViewModelProtocol!
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
        viewModel = CreateSavingsGoalViewModel(
            account: .mock(),
            route: nil,
            apiClient: apiClient
        )
    }
    
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        apiClient = nil
        disposeBag = nil
        scheduler = nil
    }
    
    func test_createGoalFailue_presentsAlert() {
        setUpApiFailure()
        setUpViewModel()
        
        viewModel
            .createGoalResultPublisher
            .accept(.failure(.networkError))
        
        XCTAssertEqual(
            viewModel.route.value,
            CreateSavingsGoalViewModel.Route.alert(.genericError)
        )
    }
    
    func test_targetInputText_correctlyFormatsMinorUnits() {
        setUpApiHappyPath()
        setUpViewModel()
        
        var input = "£120.54"
        
        var output = viewModel.convertTargetTextToMinorUnits(text: input)
        XCTAssertEqual(output, 12054)
        
        input = "£9999999.00"
        
        output = viewModel.convertTargetTextToMinorUnits(text: input)
        XCTAssertEqual(output, 999999900)
    }
    
    func test_cancel_removesAlert() {
        setUpApiHappyPath()
        setUpViewModel()
        
        viewModel.route.accept(.alert(.emptyName))
        
        XCTAssertEqual(
            viewModel.route.value,
            CreateSavingsGoalViewModel.Route.alert(.emptyName)
        )
        
        viewModel.cancelButtonTapped()
        
        XCTAssertNil(viewModel.route.value)
    }
    
    func test_whenTextIsEmpty_DoneButtonTapped_presentsAlert() {
        setUpApiHappyPath()
        setUpViewModel()
        viewModel.doneButtonTapped()
        
        XCTAssertEqual(
            viewModel.route.value,
            CreateSavingsGoalViewModel.Route.alert(.emptyName)
        )
    }
    
    func test_whenTargetIsEmpty_DoneButtonTapped_presentsAlert() {
        setUpApiHappyPath()
        setUpViewModel()
        viewModel.name.accept("Valid Name")
        viewModel.doneButtonTapped()
        
        XCTAssertEqual("Valid Name", viewModel.name.value)
        XCTAssertEqual(
            viewModel.route.value,
            CreateSavingsGoalViewModel.Route.alert(.targetTooLow)
            )
    }
    
    func test_whenFieldsAreFull_ApiIsCalled() async {
        let apiExpectation = XCTestExpectation(description: "Should attempt to post savings goal")
        let savingsGoal = CreateSavingsGoalResponse.init(savingsGoalUid: "", success: true)
        setUpApiHappyPath(callEndpointExpectation: apiExpectation, returnValue: savingsGoal)
        setUpViewModel()
        viewModel.name.accept(.validName)
        viewModel.target.accept(.validTarget)
        viewModel.doneButtonTapped()

        await fulfillment(of: [apiExpectation], timeout: 1)
    }
    
    func test_whenFieldsAreFull_CorrectRequestBodyCreated() async {
        let savingsGoal = SavingsGoalRequestBody(
            name: .validName,
            currency: .validCurrency,
            target: .init(currency: .validCurrency, minorUnits: .validTarget)
        )
        
        setUpApiHappyPath(returnValue: savingsGoal)
            
        viewModel = CreateSavingsRequestBodyPartialGoalMockViewModel(
            account: .mock(),
            apiClient: apiClient,
            savingsGoalMock: savingsGoal
        ) {
            XCTAssertEqual($0.name, $1.name)
            XCTAssertEqual($0.currency, $1.currency)
            XCTAssertEqual($0.target, $1.target)
        }
        
        viewModel.name.accept(.validName)
        viewModel.target.accept(.validTarget)
        viewModel.doneButtonTapped()
    }
        
//    TODO: -
//    func test_whenPostingGoalWithParams_stateIsUpdatedAPIE() async throws {
//        let savingsGoalResponse = CreateSavingsGoalResponse.init(savingsGoalUid: "", success: true)
//        
//        setUpApiHappyPath(returnValue: savingsGoalResponse)
//        setUpViewModel()
//    
//        viewModel.name.accept(.validName)
//        viewModel.target.accept(.validTarget)
//        viewModel.doneButtonTapped()
//        
//        let createPub = viewModel
//            .createGoalResultPublisher
//            .subscribe(on: scheduler)
//    
//          
//            XCTAssertEqual(
//                    try createPub (timeout: 1.0),
//                    Result<CreateSavingsGoalResponse, APIError>.failure(.networkError)
////                        .success(savingsGoalResponse)
//                )
//        
//            .disposed(by: disposeBag)
//    }
//    
//    func test_whenPostingGoal_isNetworkingStateIsCorrect() async throws {
//        let savingsGoalRequest = SavingsGoalRequestBody(
//            name: .validName,
//            currency: .validCurrency,
//            target: .init(currency: .validCurrency, minorUnits: .validTarget)
//        )
//        
//        let savingsGoalResponse = CreateSavingsGoalResponse.init(savingsGoalUid: "", success: true)
//        
//        setUpApiHappyPath(returnValue: savingsGoalResponse)
//        setUpViewModel()
//        
//        let networkingObsv = viewModel
//            .networkingDriver
//            .asObservable()
//            .subscribe {
//                XCTAssertFalse($0)
//            }
//        
//        
////        
////        viewModel
////            .isNetworking
////            .asObservable()
////            .skip(2)
////            .subscribe {
////                XCTAssertFalse($0)
////            }
////            .disposed(by: disposeBag)
//        
//        try await viewModel.postSavingsGoal(savingsGoalRequest)
//        
////        XCTAssertEqual(networkingObsv, true)
//
//    }
    
    
    
}
