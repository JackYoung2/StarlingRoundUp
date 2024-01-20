//
//  File.swift
//
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation
import SharedModel
import RxSwift
import RxRelay
import Common
import APIClient
import RxCocoa

public protocol CreateSavingsGoalViewModelProtocol {
    //    var apiClient: APIClient
    //    var uuid: () -> UUID
}

public typealias CreateSavingsGoalResult = Result<CreateSavingsGoalResponse, APIError>

public class CreateSavingsGoalViewModel: CreateSavingsGoalViewModelProtocol {
    
    public indirect enum Route {
        case alert(AlertState)
    }
    
    let disposeBag = DisposeBag()
    
    var account: Account
    public var route: BehaviorRelay<Route?>
    public var apiClient: APIClientProtocol
    private var isNetworking: PublishRelay<Bool> = .init()
    public var networkingDriver: Driver<Bool> {
        isNetworking.asDriver(onErrorJustReturn: false)
    }
    
    public var createGoalResultPublisher = PublishRelay<CreateSavingsGoalResult>()
    
    
    //    lazy var savingsGoalRelay = BehaviorRelay(value: )
    
    
    private(set) public var name: String = "Test"
    private var target: Int = 1110

    
    public init(
        account: Account,
        route: Route? = nil,
        apiClient: APIClientProtocol
    ) {
        self.route = BehaviorRelay<Route?>(value: nil)
        self.account = account
        self.apiClient = apiClient
        setUpSubs()
    }
    
    func doneButtonTapped() {
        guard !name.isEmpty else {
            self.route.accept(.alert(.emptyName))
            return
        }
        
        guard target > 0 else {
            self.route.accept(.alert(.targetTooLow))
            return
        }
        
        let savingsGoal = SavingsGoalRequestBody(
            name: name,
            currency: account.currency,
            target: .init(currency: account.currency, minorUnits: target)
        )
        
        Task {
            try await postSavingsGoal(savingsGoal)
        }
    }
    
    func cancelButtonTapped() {
        self.route.accept(nil)
    }
    
    func postSavingsGoal(_ savingsGoal: SavingsGoalRequestBody) async throws {
        isNetworking.accept(true)
//        try await Task.sleep(nanoseconds: 1_000_000_000)
        var endpoint = Endpoint<CreateSavingsGoalResponse>.createSavingsGoal(for: account.accountUid, goal: savingsGoal)
        let result = try await apiClient.call(&endpoint)
//        
//        let result: CreateSavingsGoalResult = .success(
//            .init(savingsGoalUid: "123", success: true)
//        )
        
//        let result: CreateSavingsGoalResult = .failure(.networkError)
        
        self.createGoalResultPublisher.accept(result)
        
//        switch result {
//        case .success(let success):
//            print("It went up")
//        case .failure(let failure):
//            switch failure {
//            case .networkError:
//                self.route.accept(.alert(.network))
//            default:
//                self.route.accept(.alert(.genericError))
//            }
//            
//        }
        
        isNetworking.accept(false)
    }
    
    func setUpSubs() {
        self
            .createGoalResultPublisher
            .filter { $0.failure }
            .subscribe { result in
                self.route.accept(.alert(.genericError))
            }
            .disposed(by: disposeBag)
    }
    
}
