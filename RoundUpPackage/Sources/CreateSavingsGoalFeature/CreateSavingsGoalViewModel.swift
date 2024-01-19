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
    
    
//    lazy var savingsGoalRelay = BehaviorRelay(value: )
    
    
    var name: String = ""
    var target: Int = 0
    
    public init(
        account: Account,
        route: Route? = nil
    ) {
        self.route = BehaviorRelay<Route?>(value: nil)
        self.account = account
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
        
        let savingsGoal = SavingsGoal(
            savingsGoalUid: UUID().uuidString,
            name: name,
            target: .init(currency: account.currency, minorUnits: target)
            )
    }
    
    func cancelButtonTapped() {
        self.route.accept(nil)
    }
    
}

extension AlertState {
    static var emptyName = Self.init(title: "Name Missing", message: "Please choose a name for your savings goal")
    static var targetTooLow = Self.init(title: "Target Too Low", message: "Targert is currently amount is currently 0. Let's aim a little higher!")
}
