//
//  CreateSavingsGoalViewController.swift
//
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Views
import Common
import RxSwift
import RxCocoa

public class CreateSavingsGoalViewController: UIViewController {
    
    var viewModel: CreateSavingsGoalViewModel
    let disposeBag = DisposeBag()
    
//    TODO: - RXify
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting(viewModel.account.currency) {
            textField.text = amountString
        }
    }
    
    let nameTextField = Components.createTextField("Name")
    let targetTextField = Components.createTextField("Target Amount")
    let nameStack = Components.createStackView(axis: .horizontal, alignment: .center)
    let targetStack = Components.createStackView()
    let divider = Components.createDivider()
    let metaStack = Components.createStackView(axis: .vertical, distribution: .fill, alignment: .leading)
    let doneButton = Components.borderButton("Done", action: #selector(doneButtonTapped))
    let indicator = Components.indicator()
    let baseView = Components.createBaseContainerView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        targetTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    public init(_ viewModel: CreateSavingsGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUpView()
        setUpSubscribers(context: self)
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
        
        view.addSubview(indicator)
        
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
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
        
        nameTextField.text = "Test"
        targetTextField.text = "100"
    }
    
    @objc func doneButtonTapped() {
        viewModel.doneButtonTapped()
    }
    
    @MainActor
    func setUpSubscribers(context: UIViewController) {
        
        var presentedViewController: UIViewController?
        
        viewModel.route
            .observe(on: MainScheduler.instance)
            .subscribe { route in
                switch route {
                case let .alert(alertState):
                    let vc = Components.alert(state: alertState)
            
                    vc.addAction(.init(title: "Ok", style: .default, handler: { _ in
                        self.viewModel.cancelButtonTapped()
                    }))
                    
//                    DispatchQueue.main.async {
                        context.present(vc, animated: true)
//                    }
                    presentedViewController = vc
                    
                case .none:
                    presentedViewController = nil
                }
            }.disposed(by: disposeBag)
        
        
        nameTextField.rx
            .text
            .orEmpty
            .subscribe(onNext: { text in
                self.viewModel.name = text
            })
            .disposed(by: disposeBag)

        
        targetTextField.rx
            .text
            .orEmpty
            .subscribe(onNext: { text in
//                TODO: - Format
                self.viewModel.target = Int(text) ?? 100
            })
            .disposed(by: disposeBag)

        
    }
}


//import SwiftUI
//import Common
//
//struct CreateSavingsGoalViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ToSwiftUI {
//            UINavigationController(rootViewController: CreateSavingsGoalViewController(.init(account: .init())))
//        }
//    }
//}
