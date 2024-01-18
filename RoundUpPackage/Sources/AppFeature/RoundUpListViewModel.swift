//
//  File.swift
//  
//
//  Created by Jack Young on 15/01/2024.
//

import Foundation
import SavingsGoalFeature
import RxSwift
import RxRelay
import SharedModel

public class RoundUpListViewModel {
    
    struct Section {
        var date: Date
        var transactions: [Transaction]
    }
    
    var route: BehaviorRelay<Route?>
    
    var transactions: [Transaction] = [
//        Transaction(amount: 4.35, category: "Transport", merchant: "Uber", date: .now),
//        Transaction(amount: 5.20, category: "Bills", merchant: "Tesco", date: .yesterday),
//        Transaction(amount: 0.87, category: "Bills", merchant: "Tesco", date: .yesterday)
    ]
    
    var tableViewSections: [Section] = [] 
    
//    {
//        transactions.reduce(into: [Section]()) { partialResult, next in
//            if let index = partialResult.firstIndex(where: { section in
//                section.date == next.date
//            }) {
//                partialResult[index].transactions.append(next)
//            } else {
//                partialResult.append(Section(date: next.date, transactions: [next]))
//            }
//        }
//    }
//
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
        case savingsGoal(SavingsGoalViewModel)
    }
    
    func roundButtonTapped() {
        self.route.accept(.savingsGoal(.init()))
//        self.route = .savingsGoal(.init())
    }
    
}
