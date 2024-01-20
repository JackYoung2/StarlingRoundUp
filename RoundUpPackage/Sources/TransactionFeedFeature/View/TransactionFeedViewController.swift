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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpSubscribers(context: self)
        Task {
            try await viewModel.fetchAccount()
            try await viewModel.fetchTransactions()
        }
    }
    
    @objc func roundToSavingsGoalButtonTapped() {
        viewModel.roundButtonTapped()
    }
    
    func setUpSubscribers(context: UIViewController) {
//        MARK: - Navigation
        var presentedViewController: UIViewController?
        
        viewModel.route
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] route in
                guard let self = self else { return }
                switch route {
                case let .savingsGoal(viewModel):
                    viewModel
                        .addToGoalSuccessPublisher
                        .filter { if case .success = $0 { return true } else { return false } }
                        .subscribe { result in
                            presentedViewController = nil
                            context.navigationController?.popViewController(animated: true)
                            viewModel.route.accept(.alert(.itWorked))
                        }
                        .disposed(by: self.disposeBag)
                    
                    let vc = SavingsGoalListViewController(viewModel)
                    context.show(vc, sender: nil)
                    
                case .none:
                    presentedViewController = nil
                    
                    break
                    
                case let .createSavingsGoal(viewModel):
                    let vc = CreateSavingsGoalViewController(viewModel)
                    context.show(vc, sender: nil)
                case let(.alert(text)):
                    let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
                    context.show(alert, sender: nil)
                }
            }.disposed(by: disposeBag)
    
        //        MARK: - UI
        
        let account = viewModel
            .accountRelay
            .asDriver(onErrorJustReturn: nil)
        
        let transactions = viewModel
            .transactions
            .asDriver(onErrorJustReturn: [])
        
        let date = viewModel
            .transactionCutOffDate
            .asDriver(onErrorJustReturn: Date())
        
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

        account
            .compactMap { $0?.name }
            .drive(accountNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        
        roundUpSumText
        .drive(roundUpButton.label.rx.text)
        .disposed(by: disposeBag)
        
        date
            .map { $0.asDateString }
            .drive(dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel
            .tableViewSections
        .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
        .disposed(by: disposeBag)
        
        let loading = Observable.combineLatest(
            transactions.asObservable(),
            account.asObservable(),
            date.asObservable(),
            roundUpSumText.asObservable(),
            
            resultSelector: { _,_,_,_ in
                false
            }
          )
            .skip(1)
          .startWith(true)
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

        loading
          .drive(roundUpButton.rx.isHidden)
          .disposed(by: disposeBag)
    }
    
}

private extension TransactionFeedViewController {
    func setUpView() {
        self.view.backgroundColor = ColorSystem.background
        self.navigationItem.title = "Transactions"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    
        tableView.register(cell: TransactionTableViewCell.self)
        
        accountStack.addArrangedSubview(accountLabel)
        accountStack.addArrangedSubview(accountNameLabel)
        dateStack.addArrangedSubview(sinceLabel)
        dateStack.addArrangedSubview(dateLabel)
        
        tableView.delegate = self
        
        roundUpStack.isLayoutMarginsRelativeArrangement = true
        roundUpStack.layoutMargins = .init(top: space4, left: space4, bottom: space4, right: space4)
        
        view.addSubview(accountStack)
        view.addSubview(dateStack)
        view.addSubview(roundUpStack)
        view.addSubview(indicator)
        
        roundUpStack.addArrangedSubview(roundUpButton)
        self.view.addSubview(tableView)
        
        
        NSLayoutConstraint.activate([
            dateStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
            dateStack.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -space3),
            
            accountStack.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: space3),
            accountStack.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -space3),
            
            tableView.topAnchor.constraint(equalTo: dateStack.bottomAnchor, constant: space3),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            
            roundUpStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            roundUpStack.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: space3),
            roundUpStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -space3),
            roundUpStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -space3),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

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
