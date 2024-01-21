//
//  File.swift
//
//
//  Created by Jack Young on 15/01/2024.
//

import UIKit
import Common
import Views
import CreateSavingsGoalFeature
import RxRelay
import RxSwift
import RxDataSources
import APIClient

public class SavingsGoalListViewController: UIViewController {
    
    //    MARK: - Dependencies
    let viewModel: SavingsGoalListViewModel
    let disposeBag = DisposeBag()
    
    //    MARK: - View Components
    let tableView = Components.baseTableView(cells: [SavingsGoalTableViewCell.self])
    let indicator = Components.indicator()
    let emptyStateView = Components.emptyStateView(text: "Hit the + button to create your first savings goal")
 
    //    MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            try await viewModel.getSavingsGoals()
        }
    }
    
    public init(_ viewModel: SavingsGoalListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = ColorSystem.background
        setUpView()
        bindViewModel(context: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    MARK: - User Input
    @objc func addButtonTapped() {
        viewModel.route.accept(.createSavingsGoal(.init(account: viewModel.account, apiClient: viewModel.apiClient)))
    }
    
    func confirmAddTapped(goalId: String) async throws {
        try await viewModel.confirmAddTapped(goalId: goalId)
    }
    
    func cancelAddTapped() {
        self.viewModel.route.accept(nil)
    }
    
    //    MARK: - Subscribers
    func bindViewModel(context: UIViewController) {
        //    MARK: - Navigation
        var presentedViewController: UIViewController?
        
        viewModel.route
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] route in
                guard let self = self else { return }
                switch route {
                case let .createSavingsGoal(savingsGoalviewModel):
                    let vc = CreateSavingsGoalViewController(savingsGoalviewModel)
                    
                    savingsGoalviewModel
                        .createGoalResultPublisher
                        .observe(on: MainScheduler.instance)
                        .filter { $0.success }
                        .subscribe { result in
                       
                            presentedViewController = nil
                            context.navigationController?.popViewController(animated: true)
                            self.viewModel.route.accept(.alert(.createGoalSuccess(savingsGoalviewModel.name.value)))
                            
                            Task {
                                try await self.viewModel.getSavingsGoals()
                            }
                            
                    }
                    .disposed(by: disposeBag)
                    
                    context.show(vc, sender: nil)
                    
                case .none:
                    presentedViewController = nil
                    presentedViewController?.dismiss(animated: true)
                    
                case let .alert(alertType):
                    let alert = Components.alert(state: alertType.alertState)
                    
                    switch alertType {
                    case let .confirmAddToGoal(_, goal):
//                    TODO: - Tidy up
                        alert.addAction(
                            .init(title: "OK", style: .default, handler: { _ in
                                presentedViewController = nil
                                Task {
                                    try await self.confirmAddTapped(goalId: goal.savingsGoalUid)
                                }
                            }))
                        
                        alert.addAction(
                            .init(title: "Cancel", style: .cancel, handler: { _ in
                                self.cancelAddTapped()
                            }))
                        
                    default:
                        alert.addAction(
                            .init(title: "OK", style: .default, handler: { _ in
                                self.cancelAddTapped()
                            }))
                    }
                    context.present(alert, animated: true)
                    presentedViewController = alert
                }
            }.disposed(by: disposeBag)
        
//    MARK: - UIBindings
        viewModel
            .tableViewSections
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
                
        viewModel
            .networkingDriver
            .drive(indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel
            .networkingDriver
            .drive(tableView.rx.isHidden)
            .disposed(by: disposeBag)
        
        let emptyGoals = viewModel
            .savingsGoals
            .map { !$0.isEmpty }
            .skip(1)
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
        
        emptyGoals
            .drive(emptyStateView.rx.isHidden)
            .disposed(by: disposeBag)
    }
}

//    MARK: - UITableViewDelegate
extension SavingsGoalListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.savingsGoals.value.count
    }

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
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didTapItem(at: indexPath)
    }
}

//    MARK: - setUpView
extension SavingsGoalListViewController {
    func setUpView() {
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = "Add \(viewModel.roundUpDisplayString) to savings goal"
        
        setUpEmptyStateView()
        
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: space3),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -space3),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -space3),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        func setUpEmptyStateView() {
            
            view.addSubview(emptyStateView)
            
            NSLayoutConstraint.activate([
                emptyStateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: space3),
                emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
                emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            ])
        }
    }
}
