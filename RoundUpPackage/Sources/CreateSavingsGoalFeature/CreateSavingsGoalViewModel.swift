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
    public let maxGoalAmountDigits: Int = 12
    
    public var networkingDriver: Driver<Bool> {
        isNetworking.asDriver(onErrorJustReturn: false)
    }
    
    public var createGoalResultPublisher = PublishRelay<CreateSavingsGoalResult>()
    public var name: BehaviorRelay<String> = .init(value: "")
    public var target: BehaviorRelay<Int> = .init(value: 0)

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
        guard !name.value.isEmpty else {
            self.route.accept(.alert(.emptyName))
            return
        }
        
        guard target.value > 0 else {
            self.route.accept(.alert(.targetTooLow))
            return
        }
        
        let savingsGoal = SavingsGoalRequestBody(
            name: name.value,
            currency: account.currency,
            target: .init(currency: account.currency, minorUnits: target.value)
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
        var endpoint = Endpoint<CreateSavingsGoalResponse>.createSavingsGoal(for: account.accountUid, goal: savingsGoal)
        let result = try await apiClient.call(&endpoint)
        self.createGoalResultPublisher.accept(result)
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
