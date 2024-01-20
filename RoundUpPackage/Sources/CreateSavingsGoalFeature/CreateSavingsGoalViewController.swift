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
    let contentStack = Components.createStackView(axis: .vertical, distribution: .fill, alignment: .leading)
    let textEntryStack = Components.createStackView(axis: .vertical, distribution: .fill, alignment: .leading)
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
        nameStack.directionalLayoutMargins = .init(top: space4, leading: space4, bottom: space4, trailing: space4)
        targetStack.isLayoutMarginsRelativeArrangement = true
        targetStack.directionalLayoutMargins = .init(top: space4, leading: space4, bottom: space4, trailing: space4)
        
        nameStack.addArrangedSubview(nameTextField)
        targetStack.addArrangedSubview(targetTextField)
        
        textEntryStack.addArrangedSubview(nameStack)
        textEntryStack.addArrangedSubview(divider)
        textEntryStack.addArrangedSubview(targetStack)
        
        
        baseView.addSubview(textEntryStack)
        contentStack.addArrangedSubview(baseView)
        contentStack.addArrangedSubview(doneButton)
        
        view.addSubview(indicator)
        view.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            
            baseView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: space3),
            baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space3),
            baseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.widthAnchor.constraint(equalTo: textEntryStack.widthAnchor),

            textEntryStack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
            textEntryStack.topAnchor.constraint(equalTo: baseView.topAnchor, constant: space3),
            textEntryStack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0),
            textEntryStack.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -space3),
            
            doneButton.topAnchor.constraint(equalTo: baseView.bottomAnchor, constant: space4),
            doneButton.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: space3),
            doneButton.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: -space3),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            contentStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStack.topAnchor.constraint(equalTo: view.topAnchor, constant: space3)

        ])
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
                    
                    context.present(vc, animated: true)
                    presentedViewController = vc
                    
                case .none:
                    presentedViewController = nil
                }
            }.disposed(by: disposeBag)
        
        
        nameTextField.rx
            .text
            .orEmpty
            .subscribe(onNext: { text in
//                TODO: -
//                self.viewModel.name = text
            })
            .disposed(by: disposeBag)

        
        targetTextField.rx
            .text
            .orEmpty
            .subscribe(onNext: { text in
//                TODO: - Format
//                self.viewModel.target = Int(text) ?? 100
            })
            .disposed(by: disposeBag)

            
        viewModel
            .networkingDriver
            .drive(indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel
            .networkingDriver
            .drive(contentStack.rx.isHidden)
            .disposed(by: disposeBag)
        
    }
}
