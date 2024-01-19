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
import RxDataSources
import SavingsGoalFeature
import CreateSavingsGoalFeature
import APIClient

public protocol SavingsGoalListViewModelProtocol {
    var savingsGoals: BehaviorRelay<[SavingsGoalViewModel]> { get }
    var dataSource: SavingsGoalDataSource { get }
    var route: BehaviorRelay<SavingsGoalListViewModel.Route?> { get }
    
    init(route: SavingsGoalListViewModel.Route?)
}

public class SavingsGoalListViewModel {
    
    public enum Route {
        case createSavingsGoal(CreateSavingsGoalViewModel)
    }
    
    var tableViewSections = BehaviorRelay<[SectionModel<String, SavingsGoalViewModel>]>(value: [])
    let savingsGoals: BehaviorRelay<[SavingsGoalViewModel]> = .init(value: [])
    
    var apiClient: APIClientProtocol
    var account: Account
    
    let disposeBag = DisposeBag()
    
//    lazy var dataSource = SavingsGoalDataSource(viewModel: self)
    
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
    
    public var route: BehaviorRelay<Route?>
    
    public init(
        route: Route? = nil, 
        apiClient: APIClientProtocol,
        account: Account
    ) {
        self.route = BehaviorRelay<Route?>(value: nil)
        self.apiClient = apiClient
        self.account = account
        setUpSubs()
    }
    
    func getSavingsGoals() async throws {
        var endpoint = Endpoint<SavingsGoalListResponse>.getSavingsGoals(for: account.accountUid)
        let result = try await apiClient.call(&endpoint)
        
        switch result {
        case let .success(response):
            print(response.savingsGoalList)
            self.savingsGoals.accept(response.savingsGoalList.map(SavingsGoalViewModel.init))
        case let .failure(error):
            print("Error")
        }
    }
    
    func setUpSubs() {
        savingsGoals.subscribe {
            self.tableViewSections.accept(
                [SectionModel(model: UUID().uuidString, items: $0)]
                )
        }.disposed(by: disposeBag)
    }
}


//let testSavingsGoals: [SavingsGoal] = []
//    SavingsGoal(
//        savingsGoalUid: "c0efc8ad-1a48-4bf3-b0c8-d2f23b370774",
//        name: "Trip to Paris",
//        target: Amount(currency: "GBP", minorUnits: 123456),
//        totalSaved: Amount(currency: "GBP", minorUnits: 0),
//        savedPercentage: 0,
//        state: "ACTIVE"
//    ),
//    SavingsGoal(
//        savingsGoalUid: "a1b2c3d4-e5f6-a7b8-c9d0-e1f2a3b4c5d6",
//        name: "New Laptop",
//        target: Amount(currency: "USD", minorUnits: 150000),
//        totalSaved: Amount(currency: "USD", minorUnits: 50000),
//        savedPercentage: 33,
//        state: "ACTIVE"
//    ),
//    SavingsGoal(
//        savingsGoalUid: "x1y2z3w4-5v6-6u7-7t8-8s9r0q1p2o3n",
//        name: "Emergency Fund",
//        target: Amount(currency: "CAD", minorUnits: 100000),
//        totalSaved: Amount(currency: "CAD", minorUnits: 25000),
//        savedPercentage: 25,
//        state: "ACTIVE"
//    ),
//    SavingsGoal(
//        savingsGoalUid: "f1e2d3c4-b5a6-f7e8-d9c0-b1a2f3e4d5c6",
//        name: "Dream Vacation",
//        target: Amount(currency: "EUR", minorUnits: 80000),
//        totalSaved: Amount(currency: "EUR", minorUnits: 20000),
//        savedPercentage: 25,
//        state: "ACTIVE"
//    ),
//    SavingsGoal(
//        savingsGoalUid: "1a2b3c4d-e5f6-g7h8-i9j0-k1l2m3n4o5p6",
//        name: "Home Renovation",
//        target: Amount(currency: "AUD", minorUnits: 200000),
//        totalSaved: Amount(currency: "AUD", minorUnits: 200000),
//        savedPercentage: 100,
//        state: "ACTIVE"
//    )
//]
//
