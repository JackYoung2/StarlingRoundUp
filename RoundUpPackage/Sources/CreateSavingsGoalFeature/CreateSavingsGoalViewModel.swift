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

public protocol CreateSavingsGoalViewModelProtocol {
    //    var apiClient: APIClient
    //    var uuid: () -> UUID
}

public class CreateSavingsGoalViewModel: CreateSavingsGoalViewModelProtocol {
    //    public var uuid: () -> UUID = {
    //        UUID().uuid
    //    }
    
    public indirect enum Route {
        case alert(AlertState)
    }
    var account: Account
    public var route: BehaviorRelay<Route?>
    public var apiClient: APIClientProtocol
    public var isNetworking: PublishRelay<Bool> = .init()
    
    
    //    lazy var savingsGoalRelay = BehaviorRelay(value: )
    
    
    var name: String = ""
    var target: Int = 0
    
    public init(
        account: Account,
        route: Route? = nil,
        apiClient: APIClientProtocol
    ) {
        self.route = BehaviorRelay<Route?>(value: nil)
        self.account = account
        self.apiClient = apiClient
        //        setUpSubs()
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
        var endpoint = Endpoint<CreateSavingsGoalResponse>.createSavingsGoal(for: account.accountUid, goal: savingsGoal)
        let result = try await apiClient.call(&endpoint)
        
        switch result {
        case .success(let success):
            print("It went up")
        case .failure(let failure):
            switch failure {
            case .networkError:
                self.route.accept(.alert(.network))
            default:
                self.route.accept(.alert(.genericError))
            }
            
        }
        
        isNetworking.accept(false)
    }
    
}
