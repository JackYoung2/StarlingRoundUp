//
//  File.swift
//  
//
//  Created by Jack Young on 15/01/2024.
//

import UIKit

public class SavingsGoalViewController: UIViewController {
    
    let viewModel: SavingsGoalViewModel

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init(_ viewModel: SavingsGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

import SwiftUI
struct SavingsGoalViewController_Previews: PreviewProvider {
    static var previews: some View {
        ToSwiftUI {
            SavingsGoalViewController(.init())
        }
    }
}
