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
    
    var viewModel: CreateSavingsGoalViewModel!
    var apiClient: APIClientProtocol!
        var disposeBag: DisposeBag!
    
    func setUpApiHappyPath(returnValue: Any? = nil) {
        apiClient = MockApiClientHappyPath(returnValue: returnValue ?? "")
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
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        apiClient = nil
        disposeBag = nil
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
    
    func test_whenFielsAreFull_ApiIsCalled() {
        let savingsGoal = SavingsGoalRequestBody(
            name: .validName,
            currency: .validCurrency,
            target: .init(currency: .validCurrency, minorUnits: .validTarget)
        )
        
        setUpApiHappyPath(returnValue: savingsGoal)
        setUpViewModel()
        viewModel.name.accept(.validName)
        viewModel.target.accept(.validTarget)
        viewModel.doneButtonTapped()
        
        
        XCTAssertEqual("Valid Name", viewModel.name.value)
        XCTAssertEqual(
            viewModel.route.value,
            CreateSavingsGoalViewModel.Route.alert(.targetTooLow)
            )
    }
    
    
}
