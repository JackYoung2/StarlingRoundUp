//
//  CreateSavingsGoalViewController.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Views

class CreateSavingsGoalViewController: UIViewController {

//    public let savingsGoalUid: String
//    public let name: String
//    public let target: Amount
//    public let totalSaved: Amount
//    public let savedPercentage: Double
//    public let state: String
    
//    let nameTextField =

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        self.view.backgroundColor = .red
        self.navigationItem.title = "Create Savings Goal"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    
    }
}


import SwiftUI
struct CreateSavingsGoalViewController_Previews: PreviewProvider {
    static var previews: some View {
        ToSwiftUI {
            UINavigationController(rootViewController: CreateSavingsGoalViewController())
            
        }
    }
}

struct ToSwiftUI: UIViewControllerRepresentable {
  let viewController: () -> UIViewController
  
  func makeUIViewController(context: Context) -> UIViewController {
    self.viewController()
  }
  
  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}
