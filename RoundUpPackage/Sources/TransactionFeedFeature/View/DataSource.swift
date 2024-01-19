//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Common
import Views

public class TransactionFeedDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {

    unowned var viewModel: TransactionFeedViewModel
    
    public init(viewModel: TransactionFeedViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableViewSections[section].transactions.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.tableViewSections.count
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.tableViewSections[section].date.relativeDate
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
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.identifier) as? TransactionTableViewCell else {
            return UITableViewCell()
        }
        
        let transaction = viewModel.tableViewSections[indexPath.section].transactions[indexPath.row]
        let isLastInSection = viewModel.tableViewSections[indexPath.section].transactions.count - 1 == indexPath.row
        cell.bind(TransactionViewModel.init(transaction: transaction), hidesDivider: isLastInSection)
        
        return cell
    }

    
}
