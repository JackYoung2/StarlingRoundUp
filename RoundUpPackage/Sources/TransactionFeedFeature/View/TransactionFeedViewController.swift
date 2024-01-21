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
    //    MARK: - Dependencies
    let disposeBag = DisposeBag()
    let viewModel = TransactionFeedViewModel()
    
    //    MARK: - View Components
    lazy var tableView = Components.baseTableView()
    let accountLabel = Components.titleLabel("Account: ")
    let accountNameLabel = Components.baseLabel()
    let accountStack = Components.createStackView(axis: .horizontal)
    let sinceLabel = Components.titleLabel("Since: ")
    let dateLabel = Components.baseLabel()
    let dateStack = Components.createStackView(axis: .horizontal)
    let indicator = Components.indicator()
    let roundUpStack = Components.createStackView()
    let roundUpButton = Components.roundUpButton(action: #selector(roundToSavingsGoalButtonTapped))
    let refreshControl = UIRefreshControl()
    let emptyStateView = Components.emptyStateView(text: "No transactions found. Spend some money to get started!")
    
    //    MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        bindViewModel(context: self)
        Task {
            try await viewModel.fetchAccount()
            try await viewModel.fetchTransactions()
        }
    }
    
    //    MARK: - User Input
    @objc func roundToSavingsGoalButtonTapped() {
        viewModel.roundButtonTapped()
    }
    
    @objc func didPullToRefresh() {
        Task {
            try await viewModel.fetchTransactions()
            refreshControl.endRefreshing()
        }
    }
    
    //    MARK: - Subscribers
    func bindViewModel(context: UIViewController) {
//        MARK: - Navigation
        var presentedViewController: UIViewController?
        
        viewModel.route
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] route in
                guard let self else { return }
                switch route {
                case let .savingsGoal(viewModel):
                    let vc = SavingsGoalListViewController(viewModel)
                    context.show(vc, sender: nil)
                    
                case .none:
                    presentedViewController?.dismiss(animated: true)
                    presentedViewController = nil
                    break
                    
                case let .createSavingsGoal(viewModel):
                    let vc = CreateSavingsGoalViewController(viewModel)
                    context.show(vc, sender: nil)
                    
                case let .alert(alertType):
                    let alert = Components.alert(state: alertType.alertState)
                    alert.addAction(
                        .init(title: "OK", style: .default, handler: { _ in
                            self.viewModel.route.accept(nil)
                        }))
                    context.show(alert, sender: nil)
                }
            }.disposed(by: disposeBag)
    
        //    MARK: - UIBindings
        
        let roundUpSumText = viewModel
            .roundUpValue
            .compactMap { [weak self] in
                guard let self = self else { return nil }
                return Amount(currency: self.viewModel.currencyCode, minorUnits: $0)
            }
            .compactMap(NumberFormatter.formattedCurrencyFrom)
            .map { "Add \($0) to savings goal" }
            .skip(1)
            .asDriver(onErrorJustReturn: "")

        viewModel
            .accountDriver
            .compactMap { $0?.name }
            .drive(accountNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        roundUpSumText
        .drive(roundUpButton.label.rx.text)
        .disposed(by: disposeBag)
        
        viewModel
            .dateDriver
            .map { $0.asDateString }
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .tableViewSections
        .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
        .disposed(by: disposeBag)
        
        let loading = Observable.combineLatest(
            viewModel.transactionsDriver.asObservable(),
            viewModel.accountDriver.asObservable(),
            viewModel.dateDriver.asObservable(),
            roundUpSumText.asObservable(),
            
            resultSelector: { _,_,_,_ in
                false
            }
          )
        .skip(1)
          .startWith(true)
          .asDriver(onErrorJustReturn: false)
        
        let emptyTransactions =
        Observable
            .combineLatest(
                loading.asObservable(),
                viewModel.transactions,
                resultSelector: { loading, transactions in
                    !loading && transactions.isEmpty
                }
            )
            .asDriver(onErrorJustReturn: false)
        
      
        loading
          .drive(indicator.rx.isAnimating)
          .disposed(by: disposeBag)
        
        loading
          .drive(tableView.rx.isHidden)
          .disposed(by: disposeBag)

        loading
          .drive(dateStack.rx.isHidden)
          .disposed(by: disposeBag)

        loading
          .drive(accountStack.rx.isHidden)
          .disposed(by: disposeBag)

        emptyTransactions
            .map { !$0 }
            .drive(emptyStateView.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyTransactions
            .startWith(true)
            .drive(roundUpStack.rx.isHidden)
            .disposed(by: disposeBag)
        
        emptyTransactions
            .skip(1)
            .startWith(true)
            .drive(roundUpButton.roundUpImage.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

//    MARK: - UITableViewDelegate
extension TransactionFeedViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .zero
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let corners = tableView.corners(for: cell, at: indexPath)
        let cornerRadius = space4
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = UIBezierPath(
            roundedRect: cell.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(
                width: cornerRadius, height: cornerRadius)
        ).cgPath
        cell.layer.mask = maskLayer
    }
}

//    MARK: - setUpView
private extension TransactionFeedViewController {
    func setUpView() {
        self.view.backgroundColor = ColorSystem.background
        self.navigationItem.title = "Transactions"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self
        tableView.register(cell: TransactionTableViewCell.self)
           refreshControl.attributedTitle = NSAttributedString(string: "Fetch Transactions")
           refreshControl.addTarget(self, action: #selector(self.didPullToRefresh), for: .valueChanged)
           tableView.addSubview(refreshControl)

        accountStack.addArrangedSubview(accountLabel)
        accountStack.addArrangedSubview(accountNameLabel)
        dateStack.addArrangedSubview(sinceLabel)
        dateStack.addArrangedSubview(dateLabel)
        roundUpStack.addArrangedSubview(roundUpButton)
        view.addSubview(accountStack)
        view.addSubview(dateStack)
        view.addSubview(roundUpStack)
        view.addSubview(indicator)
        view.addSubview(tableView)
        
        setUpEmptyStateView()
        
        NSLayoutConstraint.activate([
            dateStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
            dateStack.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -space3),
            
            accountStack.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: space3),
            accountStack.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -space3),
            
            tableView.topAnchor.constraint(equalTo: accountStack.bottomAnchor, constant: space2),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            
            roundUpStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            roundUpStack.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: space3),
            roundUpStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -space3),
            roundUpStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -space3),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        func setUpEmptyStateView() {
            view.addSubview(emptyStateView)
            NSLayoutConstraint.activate([
                emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: space3),
                emptyStateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            ])
        }
    }
}
