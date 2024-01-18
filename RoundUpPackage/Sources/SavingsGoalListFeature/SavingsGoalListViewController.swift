//
//  File.swift
//  
//
//  Created by Jack Young on 15/01/2024.
//

import UIKit
import Common
import Views

public class SavingsGoalListViewController: UIViewController {
    
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        
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
