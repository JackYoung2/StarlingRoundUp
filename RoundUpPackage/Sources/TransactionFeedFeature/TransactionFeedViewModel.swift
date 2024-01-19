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
import SharedModel
import CreateSavingsGoalFeature

protocol TransactionFeedViewModelProtocol {
    var route: BehaviorRelay<TransactionFeedViewModel.Route?> { get }
    var dataSource: TransactionFeedDataSource { get }
    var transactions: [Transaction] { get }
    var tableViewSections: [TransactionFeedViewModel.Section] { get }
    
    init(route: TransactionFeedViewModel.Route?)
    func roundButtonTapped()
}


public class TransactionFeedViewModel {
    
    enum Route {
        case savingsGoal(SavingsGoalListViewModel)
        case createSavingsGoal(CreateSavingsGoalViewModel)
    }
    
    struct Section {
        var date: Date
        var transactions: [Transaction]
    }
    
    var route: BehaviorRelay<Route?>
    lazy var dataSource = TransactionFeedDataSource(viewModel: self)
    
    let transactions = dummyTransactions
    
    var tableViewSections: [Section] {
        transactions.reduce(into: [Section]()) { partialResult, next in
            if let index = partialResult.firstIndex(where: { section in
                section.date == next.settlementTime
            }) {
                partialResult[index].transactions.append(next)
            } else {
                partialResult.append(Section(date: next.settlementTime, transactions: [next]))
            }
        }
    }

    init(
      route: Route? = nil
    ) {
        self.route = BehaviorRelay<Route?>(value: nil)
    }

    func roundButtonTapped() {
        self.route.accept(.savingsGoal(.init()))
    }
    
}
