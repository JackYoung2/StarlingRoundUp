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
    
    var transactions = BehaviorRelay<[Transaction]>(value: [])
    
    //    TODO: - Add selection period
    var transactionCutOffDate = BehaviorRelay<Date>(value: .oneWeekAgo)
    
    var accountRelay = BehaviorRelay<Account?>(value: nil)
    
    var account: Driver<Account?> {
        return accountRelay.asDriver(onErrorJustReturn: nil)
    }
    
    var tableViewSections = BehaviorRelay<[SectionModel<Date, Transaction>]>(value: [])

    init(
        apiClient: APIClient = APIClient(),
        route: Route? = nil
    ) {
        self.apiClient = apiClient
        self.route = BehaviorRelay<Route?>(value: nil)
        setUpSubscribers()
    }

    func roundButtonTapped() {
        self.route.accept(.savingsGoal(.init()))
    }
    
    func setUpSubscribers() {
       transactions
            .map {
                $0.filter { $0.direction == .out && $0.status == .settled }
            }
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
            self.transactions.accept(result.feedItems)
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
