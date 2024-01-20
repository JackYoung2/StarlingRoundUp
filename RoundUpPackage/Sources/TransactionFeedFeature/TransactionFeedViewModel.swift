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

protocol TransactionFeedViewModelProtocol {
    var route: BehaviorRelay<TransactionFeedViewModel.Route?> { get }
    var apiClient: APIClientProtocol { get set }
//    var dataSource: TransactionFeedDataSource { get }
    var transactions: BehaviorRelay<[Transaction]> { get }
//    var tableViewSections: [TransactionFeedViewModel.Section] { get }
    
    var accountRelay: BehaviorRelay<Account> { get }
    
    init(route: TransactionFeedViewModel.Route?)
    func roundButtonTapped()
}


public class TransactionFeedViewModel {
    
    enum Route {
        case savingsGoal(SavingsGoalListViewModel)
        case createSavingsGoal(CreateSavingsGoalViewModel)
        case alert(String)
    }
    
    var apiClient: APIClient
    var route: BehaviorRelay<Route?>
    
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
    
    
    let disposeBag = DisposeBag()
    
    let roundUpClient: RoundUpClientProtocol
    
   
    
    //    TODO: - Add selection period
    var transactionCutOffDate = BehaviorRelay<Date>(value: .oneWeekAgo)
    var transactions = BehaviorRelay<[Transaction]>(value: [])
    var accountRelay = BehaviorRelay<Account?>(value: nil)
    var roundUpString = BehaviorRelay<String>(value: "")
    
    var account: Driver<Account?> {
        return accountRelay.asDriver(onErrorJustReturn: nil)
    }
    
    var tableViewSections = BehaviorRelay<[SectionModel<Date, Transaction>]>(value: [])

    init(
        apiClient: APIClient = APIClient(),
        route: Route? = nil,
        roundUpClient: RoundUpClientProtocol = RoundUpClient()
    ) {
        self.apiClient = apiClient
        self.route = BehaviorRelay<Route?>(value: nil)
        self.roundUpClient = roundUpClient
        setUpSubscribers()
    }

    func roundButtonTapped() {
        guard let account = accountRelay.value else {
            preconditionFailure("Should have account")
        }
        
//        TODO: -
        self.route.accept(.savingsGoal(.init(apiClient: apiClient, account: account, roundUpAmount: .init(currency: "gbp", minorUnits: 1))))
    }
    
    func setUpSubscribers() {
       transactions
            .map {
                $0.reduce(into: [SectionModel<Date, Transaction>]()) { partialResult, next in
                    if let index = partialResult.firstIndex(where: { section in
                        section.model == next.settlementTime
                    }) {
                        partialResult[index].items.append(next)
                    } else {
                        partialResult.append(SectionModel(model: next.settlementTime, items: [next]))
                    }
                }
            }
            .bind(to: tableViewSections)
          .disposed(by: disposeBag)
        
        transactions.map { [weak self] in
            $0.reduce(into: 0) { partialResult, transaction in
                partialResult += self?.roundUpClient.roundUpSpend(
                    code: self?.accountRelay.value?.currency ?? "GBP", 
                    transaction.amount.minorUnits
                ) ?? 0
            }
        }
        .compactMap { NumberFormatter.formattedCurrencyFrom(code: "GBP", amount: $0) }
        .map { "Add \($0) to savings goal" }
        .bind(to: roundUpString)
        .disposed(by: disposeBag)
    }
    
    func fetchTransactions() async throws {
        guard let accountId = accountRelay.value?.accountUid,
        let category = accountRelay.value?.defaultCategory,
              let date = transactionCutOffDate.value.asISO8601Format
        else {
//            TODO: - Get this to work
            self.route = .init(value: .alert("No account selected"))
            return
        }
        
        var endpoint = Endpoint<TransactionFeedItemResponse>.getFeed(
            for: accountId,
            in: category,
            since: date
        )
        
        let result = try await apiClient.call(&endpoint)
        
        switch result {
        case .success(let result):
//            TODO: - Move this?
            self.transactions.accept(result.feedItems.filter { $0.direction == .out && $0.status == .settled })
        case .failure(let failure):
            print(failure)
//        TODO: - Handle failure
        }
    }
    
    func fetchAccount() async throws {
        var endpoint = Endpoint<AccountResponse>.getAccount()
        let result = try await apiClient.call(&endpoint)
        
        switch result {
        case .success(let result):
//            TODO: - Multiple accounts
            accountRelay.accept(result.accounts.first)
        case .failure(let failure):
            print(failure)
//        TODO: - Handle failure
        }
    }
    
}
