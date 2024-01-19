//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import Foundation

public protocol CreateSavingsGoalViewModelProtocol {
//    var apiClient: APIClient
}

public class CreateSavingsGoalViewModel: CreateSavingsGoalViewModelProtocol {
    
    var name: String = ""
    var target: Int = 0
    
    public init() {}
    
    func doneButtonTapped() {
        print("Done tapped")
    }
}
