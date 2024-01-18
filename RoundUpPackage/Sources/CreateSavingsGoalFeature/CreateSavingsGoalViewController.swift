//
//  CreateSavingsGoalViewController.swift
//
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Views
import Common

public class CreateSavingsGoalViewController: UIViewController {
    
//    TODO: - RXify
    @objc func myTextFieldDidChange(_ textField: UITextField) {

        if let amountString = textField.text?.currencyInputFormatting("GBP") {
            textField.text = amountString
        }
    }
    
    let nameTextField = Components.createTextField("Name")
    let targetTextField = Components.createTextField("Target Amount")
    let nameLabel = Components.titleLabel("Name")
    
    let nameStack = Components.createStackView(axis: .horizontal, alignment: .center)
    let targetStack = Components.createStackView(
)
    let divider = Components.createDivider()
    
    let metaStack = Components.createStackView(axis: .vertical, distribution: .fill, alignment: .leading)
    
    let doneButton = Components.borderButton("Done", action: nil)
    
    let baseView = Components.createBaseContainerView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        targetTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    public init(_ viewModel: CreateSavingsGoalViewModel) {
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        self.view.backgroundColor = ColorSystem.background
        self.navigationItem.title = "Create Savings Goal"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        nameStack.isLayoutMarginsRelativeArrangement = true
        nameStack.layoutMargins = .init(top: space4, left: space4, bottom: space4, right: space4)
        
        targetStack.isLayoutMarginsRelativeArrangement = true
        targetStack.layoutMargins = .init(top: space4, left: space4, bottom: space4, right: space4)
        
        nameStack.addArrangedSubview(nameTextField)
        targetStack.addArrangedSubview(targetTextField)
        
        metaStack.addArrangedSubview(nameStack)
        metaStack.addArrangedSubview(divider)
        metaStack.addArrangedSubview(targetStack)
        
        view.addSubview(doneButton)
        view.addSubview(baseView)
        view.addSubview(metaStack)
        
        NSLayoutConstraint.activate([
            
            baseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: space3),
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.widthAnchor.constraint(equalTo: metaStack.widthAnchor),

            metaStack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
            metaStack.topAnchor.constraint(equalTo: baseView.topAnchor, constant: space3),
            metaStack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0),
            metaStack.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -space3),
            
            doneButton.topAnchor.constraint(equalTo: baseView.bottomAnchor, constant: space4),
            doneButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: space3),
            doneButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -space3),

        ])
        
    }
}


import SwiftUI
struct CreateSavingsGoalViewController_Previews: PreviewProvider {
    static var previews: some View {
        ToSwiftUI {
            UINavigationController(rootViewController: CreateSavingsGoalViewController(.init()))
            
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
