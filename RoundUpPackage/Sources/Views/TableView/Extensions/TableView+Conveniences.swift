//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Common

public extension UITableView {
    func register(cell: AnyClass) {
        self.register(cell, forCellReuseIdentifier: cell.identifier)
    }
}

public extension UITableView {
    func corners(
        for cell: UITableViewCell,
        at indexPath: IndexPath
    ) -> UIRectCorner {
        var corners: UIRectCorner = []

        if indexPath.row == 0
        {
            corners.update(with: .topLeft)
            corners.update(with: .topRight)
        }

        if indexPath.row == self.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
        }

        return corners
        
    }
}
