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

public class SavingsGoalListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let viewModel: SavingsGoalListViewModel
    let tableView = Components.savingsGoalTableView()

    public override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @objc func addButtonTapped() { viewModel.route.accept(.createSavingsGoal(.init())) }
    
    func setUpView() {
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
       
        guard !viewModel.savingsGoals.value.isEmpty else {
            setUpEmptyStateView()
            return
        }
        
        tableView.dataSource = viewModel.dataSource
        tableView.delegate = self
        
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: space3),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space3)
        ])
    }
    
    func setUpEmptyStateView() {
        
        let baseView = Components.createBaseContainerView()
        let label = Components.baseLabel("Hit the + button to create your first savings goal")
        label.textAlignment = .center
        
        baseView.addSubview(label)
        view.addSubview(baseView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: space3),
            label.topAnchor.constraint(equalTo: baseView.topAnchor, constant: space3),
            label.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -space3),
            label.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -space3),

            baseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: space3),
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
//            baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -space3)
        ])
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
