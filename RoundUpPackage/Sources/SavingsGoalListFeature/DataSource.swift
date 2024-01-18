//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation
import UIKit

public class SavingsGoalDataSource: NSObject, UITableViewDataSource, ObservableObject {

    unowned var viewModel: SavingsGoalListViewModel
    
    init(viewModel: SavingsGoalListViewModel) {
        self.viewModel = viewModel
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.savingsGoals.value.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavingsGoalTableViewCell.identifier, for: indexPath) as! SavingsGoalTableViewCell
        
        let savingsGoal = viewModel.savingsGoals.value[indexPath.row]
        cell.bind(savingsGoal)
        return cell
    }
    
    
}
