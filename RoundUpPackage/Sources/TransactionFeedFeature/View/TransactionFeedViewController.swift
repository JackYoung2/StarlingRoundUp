//
//  ViewController.swift
//  StarlingRoundUp
//
//  Created by Jack Young on 09/01/2024.
//

import UIKit
import Views
import Common
import SharedModel
import RxSwift
import SavingsGoalListFeature
import CreateSavingsGoalFeature

public class TransactionFeedViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = TransactionFeedViewModel()

    let accountLabel = Components.titleLabel("Account: ")
    let accountNameLabel = Components.baseLabel("Primary")
    let accountStack = Components.createStackView(axis: .horizontal)
    
    let weekLabel = Components.titleLabel("Week Beginning: ")
    let dateLabel = Components.baseLabel("01/01/25")
    let dateStack = Components.createStackView(axis: .horizontal)
    
    let roundUpStack = Components.createStackView()
//    TODO: - Format properly
    let roundUpButton = Components.roundUpButton("£100", action: #selector(roundToSavingsGoalButtonTapped))

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpSubscribers(context: self)
    }

    @objc func roundToSavingsGoalButtonTapped() {
        viewModel.roundButtonTapped()
    }
    
    func setUpSubscribers(context: UIViewController) {
        viewModel.route
            .subscribe { route in
                switch route {
                case let .savingsGoal(viewModel):
                    let vc = SavingsGoalListViewController(viewModel)
                    context.show(vc, sender: nil)
                    
                case .none:
                    break
                case let .createSavingsGoal(viewModel):
                    let vc = CreateSavingsGoalViewController(viewModel)
                    context.show(vc, sender: nil)
                }
            }.disposed(by: disposeBag)
    }
    
}

private extension TransactionFeedViewController {
    func setUpView() {
        self.view.backgroundColor = ColorSystem.background
        self.navigationItem.title = "Transactions"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        let tableView = Components.baseTableView(delegate: viewModel.dataSource, dataSource: viewModel.dataSource)
        
        tableView.register(cell: TransactionTableViewCell.self)
        
        accountStack.addArrangedSubview(accountLabel)
        accountStack.addArrangedSubview(accountNameLabel)
        dateStack.addArrangedSubview(weekLabel)
        dateStack.addArrangedSubview(dateLabel)
        
        roundUpStack.isLayoutMarginsRelativeArrangement = true
        roundUpStack.layoutMargins = .init(top: space4, left: space4, bottom: space4, right: space4)
        
        view.addSubview(accountStack)
        view.addSubview(dateStack)
        view.addSubview(roundUpStack)
        
//        stack.addArrangedSubview(button)
        roundUpStack.addArrangedSubview(roundUpButton)
        
        
        self.view.addSubview(tableView)
        

        NSLayoutConstraint.activate([
            dateStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
            accountStack.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: space3),
//            accountStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            accountStack.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -space3),
            dateStack.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -space3),
            
            tableView.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: space3),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            
            roundUpStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            roundUpStack.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: space3),
            roundUpStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -space3),
            roundUpStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -space3),
        ])
        
        
        tableView.reloadData()
    }
}

public extension Date {
    static var now = Date()
    static var yesterday: Date {
        Date.now.addingTimeInterval(-86400)
    }
    
    static var distantPast: Date {
        Date.now.addingTimeInterval(-186400)
    }
}
