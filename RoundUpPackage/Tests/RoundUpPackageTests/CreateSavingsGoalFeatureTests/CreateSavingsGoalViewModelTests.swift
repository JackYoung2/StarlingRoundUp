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
import CreateSavingsGoalFeature

class CreateSavingsGoalViewModelTests: XCTestCase {
    
    var viewModel: CreateSavingsGoalViewModel!
    var apiClient: APIClientProtocol!
    //    var disposeBag: DisposeBag!
    
    func setUpApiHappyPath() {
        apiClient = MockApiClientHappyPath(returnValue: "Success")
    }
    
    func setUpApiFailure(_ error: APIError = .networkError) {
        apiClient = MockApiClientFailure(error: error)
    }
    
    override func setUpWithError() throws {
        viewModel = CreateSavingsGoalViewModel(
            account: .mock(),
            route: nil,
            apiClient: apiClient
        )
    }
    //
    override func tearDownWithError() throws {
        viewModel = nil
        apiClient = nil
        //            disposeBag = nil
    }
    
    func test_createGoalFailue_presentsAlert() {
        setUpApiFailure()
        let viewModel = CreateSavingsGoalViewModel(
            account: .mock(),
            route: nil,
            apiClient: apiClient
        )
        
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
        
        
        
    }
    
    
}
