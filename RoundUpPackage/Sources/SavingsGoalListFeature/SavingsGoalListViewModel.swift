//
//  File.swift
//
//
//  Created by Jack Young on 15/01/2024.
//

import UIKit
import SharedModel
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources
import SavingsGoalFeature
import CreateSavingsGoalFeature
import APIClient
import Common
import SessionManager

//    MARK: - Abstractions

protocol SavingsGoalListViewModelProtocol: AnyObject {
    var route: BehaviorRelay<SavingsGoalListViewModel.Route?> { get }
    var apiClient: APIClientProtocol { get }
    var roundUpAmount: Amount { get }
    var account: Account { get }
    var savingsGoals: BehaviorRelay<[SavingsGoalViewModel]> { get }
    var getSavingsGoalsListResultPublisher: PublishRelay<GetSavingsGoalsListResult> { get }
    var addToGoalResultPublisher: PublishRelay<SavingsGoalListViewModel.SavingsGoalWrapper> { get }
    var isNetworking: PublishRelay<Bool> { get }
    var networkingDriver: Driver<Bool> { get }
    var titleString: String { get }
    var roundUpDisplayString: String { get }
    func confirmAddTapped(goalId: String) async throws
    func didTapItem(at indexPath: IndexPath)
    func getSavingsGoals() async throws
    func addToGoal(goalId: String) async throws
//    func setUpSubscribers()
}


public typealias AddToGoalsResult = Result<SavingsGoalTransferResponse, APIError>
public typealias GetSavingsGoalsListResult = Result<SavingsGoalListResponse, APIError>

//    MARK: - Concretion
public class SavingsGoalListViewModel: SavingsGoalListViewModelProtocol {
    
    //    MARK: - Navigation
    public indirect enum Route {
        case createSavingsGoal(CreateSavingsGoalViewModel)
        case alert(AlertType)
    }
    public var route: BehaviorRelay<Route?>
    
    //    MARK: - Dependencies
    let disposeBag = DisposeBag()
    public var apiClient: APIClientProtocol
    public let sessionManager: SessionManagerProtocol
    
    public struct SavingsGoalWrapper {
        var goalId: String
        var result: AddToGoalsResult
    }
    
    //    MARK: - Constants
    public let roundUpAmount: Amount
    public let account: Account
    
    //    MARK: - Drivers + relays
    var tableViewSections = BehaviorRelay<[SectionModel<String, SavingsGoalViewModel>]>(value: [])
    public let savingsGoals: BehaviorRelay<[SavingsGoalViewModel]> = .init(value: [])
    public let getSavingsGoalsListResultPublisher = PublishRelay<GetSavingsGoalsListResult>()
    public let addToGoalResultPublisher = PublishRelay<SavingsGoalWrapper>()
    public var isNetworking: PublishRelay<Bool> = .init()
    public var networkingDriver: Driver<Bool> { isNetworking.asDriver(onErrorJustReturn: false) }
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, SavingsGoalViewModel>>(
        configureCell: { [weak self] (_, tableView, indexPath, element) in
            
            guard let self = self, let cell = tableView.dequeueReusableCell(
                withIdentifier: SavingsGoalTableViewCell.identifier
            ) as? SavingsGoalTableViewCell else {
                return UITableViewCell()
            }
            
            let savingsGoal = self.savingsGoals.value[indexPath.row]
            cell.bind(savingsGoal)
            
            return cell
        }
    )
    

    //    MARK: - Text formatting
    public var titleString: String { "Add\(" " + roundUpDisplayString) to Savings Goal" }
    
    public var roundUpDisplayString: String {
        NumberFormatter.formattedCurrencyFrom(amount: roundUpAmount) ?? ""
    }
    
//    MARK: - Init
    public init(
        route: Route? = nil,
        apiClient: APIClientProtocol,
        account: Account,
        roundUpAmount: Amount,
        sessionManager: SessionManagerProtocol
    ) {
        self.route = BehaviorRelay<Route?>(value: nil)
        self.apiClient = apiClient
        self.account = account
        self.roundUpAmount = roundUpAmount
        self.sessionManager = sessionManager
        setUpSubscribers()
    }
    
    //    MARK: - User input
    public func confirmAddTapped(goalId: String) async throws {
       try await addToGoal(goalId: goalId)
    }
    
    public func didTapItem(at indexPath: IndexPath) {
        guard let amountString = NumberFormatter.formattedCurrencyFrom(amount: roundUpAmount) else { return }
        let tappedGoal = self.savingsGoals.value[indexPath.row]
        route.accept(.alert(.confirmAddToGoal(amountString, tappedGoal.savingsGoal)))
    }
    
    //    MARK: - Dependency Integration
    public func getSavingsGoals() async throws {
        isNetworking.accept(true)
        var endpoint = Endpoint<SavingsGoalListResponse>.getSavingsGoals(for: account.accountUid)
        guard let session = try? sessionManager.getSession() else { throw APIError.noToken }
        let result = try await apiClient.call(&endpoint, token: session.token, userAgent: session.userAgent)
        getSavingsGoalsListResultPublisher.accept(result)
        isNetworking.accept(false)
    }
    
    func addToGoal(goalId: String) async throws {
        isNetworking.accept(true)
        
        guard let amountData = try? JSONEncoder().encode(TopUpRequest(amount: roundUpAmount)) else {
            self.route.accept(.alert(.genericError))
            return
        }
        
        var endpoint = Endpoint<SavingsGoalTransferResponse>.add(
            amountData,
            to: goalId,
            for: account.accountUid,
            with: UUID().uuidString
        )
        
        guard let session = try? sessionManager.getSession() else { throw APIError.noToken }
        let result = try await apiClient.call(&endpoint, token: session.token, userAgent: session.userAgent)
        let wrapper = SavingsGoalWrapper(goalId: goalId, result: result)
        addToGoalResultPublisher.accept(wrapper)
        isNetworking.accept(false)
    }
    
    
    //    MARK: - State management
    func setUpSubscribers() {
        savingsGoals.subscribe {
            self.tableViewSections.accept(
                [SectionModel(model: UUID().uuidString, items: $0)]
            )
        }.disposed(by: disposeBag)
        
        self
            .getSavingsGoalsListResultPublisher
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    self?.savingsGoals.accept(response.savingsGoalList.map(SavingsGoalViewModel.init))
                case let .failure(error):
                    switch error {
                    case .networkError:
                        self?.route.accept(.alert(.network))
                    case .tokenExpired:
                        self?.sessionManager.removeSession()
                    default:
                        self?.route.accept(.alert(.genericError))
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        self
            .addToGoalResultPublisher
            .subscribe { [weak self] wrapper in
                guard let self else { return }
                switch wrapper.result {
                case .success:
                    
                    let goalName = self.savingsGoals.value.first(where: {
                        $0.savingsGoalUid == wrapper.goalId
                    })?.name ?? ""
                    
                    self.route.accept(
                        .alert(
                            .savingsAddedSuccesfully(
                                NumberFormatter.formattedCurrencyFrom(amount: self.roundUpAmount) ?? "",
                                goalName
                            )
                        )
                    )
                    
                    Task {
                        try await self.getSavingsGoals()
                    }
                    
                case let .failure(error):
                    switch error {
                    case .networkError:
                        self.route.accept(.alert(.network))
                    case .tokenExpired:
                        self.sessionManager.removeSession()
                    default:
                        self.route.accept(.alert(.genericError))
                    }
                    
                }
            }
            .disposed(by: disposeBag)
    }
}
