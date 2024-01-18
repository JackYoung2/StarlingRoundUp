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

public class RoundUpListViewModel {
    
    struct Section {
        var date: Date
        var transactions: [Transaction]
    }
    
    var route: BehaviorRelay<Route?>
    lazy var dataSource = RoundUpListDataSource(viewModel: self)
    
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

//    
    init(
      route: Route? = nil
    ) {
        self.route = BehaviorRelay<Route?>(value: nil)
//        self.tableViewSections.append(
//            Section(date: Date(), transactions: transactions)
//        )
    }
    
    enum Route {
        case savingsGoal(SavingsGoalListViewModel)
    }
    
    func roundButtonTapped() {
        self.route.accept(.savingsGoal(.init()))
//        self.route = .savingsGoal(.init())
    }
    
}
