//
//  File.swift
//  
//
//  Created by Jack Young on 15/01/2024.
//

import Foundation
import SavingsGoalListFeature
import RxSwift
import RxRelay
import RxCocoa
import SharedModel
import CreateSavingsGoalFeature
import APIClient
import AccountsFeature
import RxDataSources
import UIKit
import RoundUpClient
import Common

//    MARK: - Abstraction
protocol TransactionFeedViewModelProtocol {
    var route: BehaviorRelay<TransactionFeedViewModel.Route?> { get }
    var apiClient: APIClientProtocol { get }
    var transactions: BehaviorRelay<[Transaction]> { get }
//    var accountRelay: BehaviorRelay<Account> { get }
    func roundButtonTapped()
}

public typealias GetTransactionFeedResult = Result<TransactionFeedItemResponse, APIError>
public typealias GetAccountResult = Result<AccountResponse, APIError>

//    MARK: - Concretion
public class TransactionFeedViewModel:TransactionFeedViewModelProtocol {

    //    MARK: - Navigation
    enum Route {
        case savingsGoal(SavingsGoalListViewModel)
        case createSavingsGoal(CreateSavingsGoalViewModel)
        case alert(AlertType)
    }
    
    var route: BehaviorRelay<Route?>
    
    //    MARK: - Dependencies
    var apiClient: APIClientProtocol
    let disposeBag = DisposeBag()
    let roundUpClient: RoundUpClientProtocol
    
    //    MARK: - Relays
    //    TODO: - Add selection period
    let transactionCutOffDate = BehaviorRelay<Date>(value: .oneWeekAgo)
    let transactions = BehaviorRelay<[Transaction]>(value: [])
    let accountRelay = BehaviorRelay<Account?>(value: nil)
    let roundUpValue = BehaviorRelay<Int>(value: 0)
    let tableViewSections = BehaviorRelay<[SectionModel<Date, Transaction>]>(value: [])
    public let getTransactionFeedResultPublisher = PublishRelay<GetTransactionFeedResult>()
    public let getAccountResultPublisher = PublishRelay<GetAccountResult>()
    
    lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Date, Transaction>>(
        configureCell: { [weak self] (_, tableView, indexPath, element) in
            guard let self = self, let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier) as? TransactionTableViewCell else {
                return UITableViewCell()
            }
            
            let transaction = self.tableViewSections.value[indexPath.section].items[indexPath.row]
            let isLastInSection = self.tableViewSections.value[indexPath.section].items.count - 1 == indexPath.row
            cell.bind(TransactionViewModel.init(transaction: transaction), hidesDivider: isLastInSection)
            
            return cell
        },
        titleForHeaderInSection: { dataSource, sectionIndex in
            return dataSource[sectionIndex].model.asDateString
        }
    )

    
    //    MARK: - Drivers
    public var accountDriver: Driver<Account?> { accountRelay.asDriver(onErrorJustReturn: nil) }
    public var transactionsDriver: Driver<[Transaction]> { transactions.asDriver(onErrorJustReturn: []) }
    public var dateDriver: Driver<Date> { transactionCutOffDate.asDriver(onErrorJustReturn: Date()) }
    
    //    MARK: - Text formatting
    var currencyCode: String { accountRelay.value?.currency ?? "" }
    
    //    MARK: - Init
    init(
        apiClient: APIClientProtocol = APIClient(),
        route: Route? = nil,
        roundUpClient: RoundUpClientProtocol = RoundUpClient()
    ) {
        self.apiClient = apiClient
        self.route = BehaviorRelay<Route?>(value: nil)
        self.roundUpClient = roundUpClient
        setUpSubscribers()
    }

    //    MARK: - User input
    func roundButtonTapped() {
        guard let account = accountRelay.value else { assert(false, "Should have account") }
        
        self.route.accept(
            .savingsGoal(
                .init(
                    apiClient: apiClient, 
                    account: account,
                    roundUpAmount: .init(currency: account.currency, minorUnits: roundUpValue.value)
                )
            )
        )
    }
    
    //    MARK: - Dependency Integration
    func fetchTransactions() async throws {
        guard let accountId = accountRelay.value?.accountUid,
        let category = accountRelay.value?.defaultCategory,
              let date = transactionCutOffDate.value.asISO8601Format
        else {
            self.route = .init(value: .alert(.network))
            return
        }
        
        var endpoint = Endpoint<TransactionFeedItemResponse>.getFeed(
            for: accountId,
            in: category,
            since: date
        )
        
        let result = try await apiClient.call(&endpoint)
        getTransactionFeedResultPublisher.accept(result)
    }
    
    func fetchAccount() async throws {
        // TODO: - Networking response failure causes broken state
        var endpoint = Endpoint<AccountResponse>.getAccount()
        let result = try await apiClient.call(&endpoint)
        getAccountResultPublisher.accept(result)
    }
    
    //    MARK: - State management
    func setUpSubscribers() {
       transactions
            .map {
                $0.reduce(into: [SectionModel<Date, Transaction>]()) { partialResult, next in
                    if let index = partialResult.firstIndex(where: { section in
                        let sameDay = Calendar.current.isDate(section.model, equalTo: next.settlementTime, toGranularity: .day)
                        return sameDay
                    }) {
                        partialResult[index].items.append(next)
                    } else {
                        partialResult.append(SectionModel(model: next.settlementTime, items: [next]))
                    }
                }
            }
            .bind(to: tableViewSections)
          .disposed(by: disposeBag)
        
        transactions
            .map { [weak self] in
                guard let self = self else { return 0 }
                
            return $0.reduce(into: 0) { partialResult, transaction in
                partialResult += self.roundUpClient.roundUpSpend(
                    code: self.currencyCode,
                    transaction.amount.minorUnits
                )
            }
        }
        .bind(to: roundUpValue)
        .disposed(by: disposeBag)
        
        self
            .getAccountResultPublisher
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
//                    TODO: - Allow user to switch accounts
                    self?.accountRelay.accept(response.accounts.first)
                    
                case let .failure(error):
                    switch error {
                    case .networkError:
                        self?.route.accept(.alert(.network))
                    case .parsingError:
                        self?.route.accept(.alert(.genericError))
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
        self
            .getTransactionFeedResultPublisher
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    self?.transactions.accept(response.feedItems)
                    
                case let .failure(error):
                    switch error {
                    case .networkError:
                        self?.route.accept(.alert(.network))
                    case .parsingError:
                        self?.route.accept(.alert(.genericError))
                    }
                    
                }
            }
            .disposed(by: disposeBag)
    }
}
