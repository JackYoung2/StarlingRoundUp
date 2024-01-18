//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Views

extension Components {
    static func savingsGoalTableView() -> UITableView {
        Self.baseTableView(cells: [SavingsGoalTableViewCell.self])
    }
}
