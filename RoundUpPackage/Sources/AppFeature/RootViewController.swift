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
import Transaction
import RxSwift
import SavingsGoalListFeature

public class RootViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = RoundUpListViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpSubscribers(context: self)
    }

    @objc func roundUp() {
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
                }
            }.disposed(by: disposeBag)
    }
    
    
}

private extension RootViewController {
    func setUpView() {
        self.view.backgroundColor = ColorSystem.background
        self.navigationItem.title = "Transactions"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        //        self.navigationController?.navigationItem.rightBarButtonItem = .
        
        let stack = Components.createStackView()
        
        let baseView = Components.createBaseContainerView()
        let button = Components.createPrimaryButton("Round", space2, action: #selector(roundUp))
        
        let tableView = Components.baseTableView(delegate: viewModel.dataSource, dataSource: viewModel.dataSource)
        
        tableView.register(cell: TransactionTableViewCell.self)
        
        baseView.addSubview(stack)
        stack.addArrangedSubview(button)
        stack.addArrangedSubview(MyCustomView())
        
        
        self.view.addSubview(baseView)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            stack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -space6),
            stack.topAnchor.constraint(equalTo: baseView.topAnchor, constant: space2),
            stack.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -space2),
            
            baseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            
            //            tableView.leadingAnchor.constraint(equalTo: secondBaseView.leadingAnchor, constant: space3),
            //            tableView.topAnchor.constraint(equalTo: secondBaseView.topAnchor),
            //            tableView.trailingAnchor.constraint(equalTo: secondBaseView.trailingAnchor, constant: -space3),
            //            tableView.bottomAnchor.constraint(equalTo: secondBaseView.bottomAnchor, constant: -space3),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            tableView.topAnchor.constraint(equalTo: baseView.bottomAnchor, constant: space3),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
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
