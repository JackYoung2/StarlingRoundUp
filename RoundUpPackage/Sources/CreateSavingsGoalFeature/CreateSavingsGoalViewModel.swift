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

//    MARK: - Abstraction

public protocol CreateSavingsGoalViewModelProtocol: AnyObject {
    var apiClient: APIClientProtocol { get set }
    
    var route: BehaviorRelay<CreateSavingsGoalViewModel.Route?> { get }
    var networkingDriver: Driver<Bool> { get }
    var createGoalResultPublisher: PublishRelay<CreateSavingsGoalResult> { get }
    var name: BehaviorRelay<String> { get }
    var target: BehaviorRelay<Int> { get }
    
    func doneButtonTapped()
    func cancelButtonTapped()
    func postSavingsGoal(_ savingsGoal: SavingsGoalRequestBody) async throws
}


public typealias CreateSavingsGoalResult = Result<CreateSavingsGoalResponse, APIError>

//    MARK: - Concretion
public class CreateSavingsGoalViewModel: CreateSavingsGoalViewModelProtocol {
    
    //    MARK: - Navigation
    public indirect enum Route {
        case alert(AlertState)
    }
    public var route: BehaviorRelay<Route?>
    
    //    MARK: - Dependencies
    let disposeBag = DisposeBag()
    public var apiClient: APIClientProtocol
    
    //    MARK: - Constants
    public let maxGoalAmountDigits: Int = 12
    let account: Account
    
    //    MARK: - Drivers + relays
    public var networkingDriver: Driver<Bool> { isNetworking.asDriver(onErrorJustReturn: false) }
    private let isNetworking: PublishRelay<Bool> = .init()
    public let createGoalResultPublisher = PublishRelay<CreateSavingsGoalResult>()
    public let name: BehaviorRelay<String> = .init(value: "")
    public let target: BehaviorRelay<Int> = .init(value: 0)

    //    MARK: - Init
    public init(
        account: Account,
        route: Route? = nil,
        apiClient: APIClientProtocol
    ) {
        self.route = BehaviorRelay<Route?>(value: nil)
        self.account = account
        self.apiClient = apiClient
        setUpSubscribers()
    }
    
    //    MARK: - State management
    func setUpSubscribers() {
        self
            .createGoalResultPublisher
            .filter { $0.failure }
            .subscribe { result in
                self.route.accept(.alert(.genericError))
            }
            .disposed(by: disposeBag)
    }
    
    func convertTargetTextToMinorUnits(text: String) -> Int? {
        let formatter = NumberFormatter.currencyFormatter(for: account.currency)
        guard let majorUnit = formatter.number(from: text) as? Double else { return nil }
        let minorUnit = majorUnit * pow(10, Double(formatter.maximumFractionDigits))
        return Int(minorUnit)
    }
    
    //    MARK: - User input
    public func doneButtonTapped() {
        guard !name.value.isEmpty else { self.route.accept(.alert(.emptyName)); return }
        guard target.value > 0 else { self.route.accept(.alert(.targetTooLow)); return }
        
//        TODO: - Add functionality to prevent copy and paste
        
        let savingsGoal = SavingsGoalRequestBody(
            name: name.value,
            currency: account.currency,
            target: .init(currency: account.currency, minorUnits: target.value)
        )
        
        Task { try await postSavingsGoal(savingsGoal) }
    }
    
    public func cancelButtonTapped() {
        self.route.accept(nil)
    }
    
    //    MARK: - Dependency Integration
    public func postSavingsGoal(_ savingsGoal: SavingsGoalRequestBody) async throws {
        isNetworking.accept(true)
        var endpoint = Endpoint<CreateSavingsGoalResponse>.createSavingsGoal(for: account.accountUid, goal: savingsGoal)
        let result = try await apiClient.call(&endpoint)
        self.createGoalResultPublisher.accept(result)
        isNetworking.accept(false)
    }
}
