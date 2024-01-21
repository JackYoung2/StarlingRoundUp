////
////  File.swift
////  
////
////  Created by Jack Young on 21/01/2024.
////
//
//import RxSwift
//import RxCocoa
//
//public struct CreateSavingsGoalMockViewModel: CreateSavingsGoalViewModelProtocol {
//    
//    // MARK: - Properties
//    
//    public var route: BehaviorRelay<CreateSavingsGoalViewModel.Route?> = .init(value: nil)
//    public var networkingDriver: Driver<Bool> { isNetworking.asDriver(onErrorJustReturn: false) }
//    public var createGoalResultPublisher: PublishRelay<CreateSavingsGoalResult> = .init()
//    public var name: BehaviorRelay<String> = .init(value: "")
//    public var target: BehaviorRelay<Int> = .init(value: 0)
//    
//    // MARK: - Private Properties
//    
//    private let isNetworking: PublishRelay<Bool> = .init()
//    
//    // MARK: - Methods
//    
//    public func doneButtonTapped() {
//        // Mock implementation for doneButtonTapped
//    }
//    
//    public func cancelButtonTapped() {
//        // Mock implementation for cancelButtonTapped
//    }
//    
//    public func postSavingsGoal(_ savingsGoal: SavingsGoalRequestBody) async throws {
//        // Mock implementation for postSavingsGoal
//    }
//    
//}
