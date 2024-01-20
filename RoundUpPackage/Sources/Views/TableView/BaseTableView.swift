//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Common

public extension Components {
    static func baseTableView(
        cells: [AnyClass] = [],
        delegate: UITableViewDelegate? = nil,
        dataSource: UITableViewDataSource? = nil
    ) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.separatorStyle = .none
        tableView.backgroundColor = .red
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: space2, bottom: 0, right: 0)
        tableView.sectionFooterHeight = 0.0
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        cells.forEach { tableView.register(cell: $0) }
        
        return tableView
    }
}
