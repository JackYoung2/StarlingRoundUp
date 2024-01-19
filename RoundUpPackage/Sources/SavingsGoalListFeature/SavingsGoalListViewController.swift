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

public class SavingsGoalListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel: SavingsGoalListViewModel
    let tableView = Components.savingsGoalTableView()
    let indicator = Components.indicator()
    
    let emptyStatebaseView = Components.createBaseContainerView()
    let emptyStatelabel = Components.baseLabel("Hit the + button to create your first savings goal")

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
        setUpSubscribers(context: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addButtonTapped() {
        viewModel.route.accept(.createSavingsGoal(.init(account: viewModel.account, apiClient: viewModel.apiClient)))
    }
    

    
    func setUpView() {
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
     
//        self.configureNavigationTitle(viewModel.titleString)
    
        setUpEmptyStateView()
        
        tableView.delegate = self
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: space3),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space3),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        func setUpEmptyStateView() {
            emptyStatelabel.textAlignment = .center
            
            emptyStatebaseView.addSubview(emptyStatelabel)
            view.addSubview(emptyStatebaseView)
            
            NSLayoutConstraint.activate([
                emptyStatelabel.leadingAnchor.constraint(equalTo: emptyStatebaseView.leadingAnchor, constant: space3),
                emptyStatelabel.topAnchor.constraint(equalTo: emptyStatebaseView.topAnchor, constant: space3),
                emptyStatelabel.trailingAnchor.constraint(equalTo: emptyStatebaseView.trailingAnchor, constant: -space3),
                emptyStatelabel.bottomAnchor.constraint(equalTo: emptyStatebaseView.bottomAnchor, constant: -space3),

                emptyStatebaseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: space3),
                emptyStatebaseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
                emptyStatebaseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
    //            baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space3)
            ])
        }
    }
    
    
    
    func setUpSubscribers(context: UIViewController) {
        viewModel.route
            .subscribe { route in
                switch route {
                case let .createSavingsGoal(viewModel):
                    let vc = CreateSavingsGoalViewController(viewModel)
                    context.show(vc, sender: nil)
                case .none:
                    break
                }
            }.disposed(by: disposeBag)
        

        viewModel
            .tableViewSections
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)
        
        let waitForit = viewModel.savingsGoals
            .asObservable()
            .map { _ in false }
            .skip(1)
            .startWith(true)
            .asDriver(onErrorJustReturn: false)
        
        waitForit
            .drive(indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
       
        let emptyGoals = viewModel
            .savingsGoals
            .map { !$0.isEmpty }
            .skip(1)
          .startWith(true)
            .asDriver(onErrorJustReturn: false)
        
        emptyGoals
            .drive(emptyStatebaseView.rx.isHidden)
            .disposed(by: disposeBag)
        
//        loading
//          .drive(dateStack.rx.isHidden)
//          .disposed(by: disposeBag)
        
    }
}


extension SavingsGoalListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.savingsGoals.value.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        1
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
}
