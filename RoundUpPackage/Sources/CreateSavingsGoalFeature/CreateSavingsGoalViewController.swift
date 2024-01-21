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
    
//    MARK: - Dependencies
    var viewModel: CreateSavingsGoalViewModel
    let disposeBag = DisposeBag()
    
    //    MARK: - View Components
    let contentStack = Components.createStackView(axis: .vertical, spacing: space5, distribution: .fill, alignment: .fill)
    let baseView = Components.createBaseContainerView()
    let textEntryStack = Components.createStackView(axis: .vertical, distribution: .fill, alignment: .leading)
    let nameStack = Components.createStackView(axis: .horizontal, alignment: .center)
    let targetStack = Components.createStackView()
    let nameTextField = Components.createTextField("Name")
    let divider = Components.createDivider()
    let targetTextField = Components.createTextField("Target Amount")
    let doneButton = Components.borderButton("Done", action: #selector(doneButtonTapped))
    let indicator = Components.indicator()
    
    //    MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        targetTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
    }
    
    public init(_ viewModel: CreateSavingsGoalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUpView()
        bindViewModel(context: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //    MARK: - User Input
    
    @objc func doneButtonTapped() {
        viewModel.doneButtonTapped()
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting(viewModel.account.currency) {
            textField.text = amountString
        }
    }
    
    //    MARK: - Subscribers

    func bindViewModel(context: UIViewController) {
        
        var presentedViewController: UIViewController?
        
        //    MARK: - Navigation
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
                    presentedViewController?.dismiss(animated: true)
                }
            }.disposed(by: disposeBag)
        
        //    MARK: - UIBindings
        nameTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.name)
            .disposed(by: disposeBag)

        
        targetTextField.rx
            .text
            .orEmpty
            .compactMap { [weak self] in
                guard let self else { return nil }
                return self.convertTargetTextToMinorUnits(text: $0)
            }
            .bind(to: viewModel.target)
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

//    MARK: - Text Field Formatting
extension CreateSavingsGoalViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = viewModel.maxGoalAmountDigits
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
    }
    
    func convertTargetTextToMinorUnits(text: String) -> Int? {
        let formatter = NumberFormatter.currencyFormatter(for: self.viewModel.account.currency)
        guard let majorUnit = formatter.number(from: text) as? Double else { return nil }
        let minorUnit = majorUnit * pow(10, Double(formatter.maximumFractionDigits))
        return Int(minorUnit)
    }
}

//    MARK: - setUpView
extension CreateSavingsGoalViewController {

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
        
        targetTextField.delegate = self
        
        
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.widthAnchor.constraint(equalTo: textEntryStack.widthAnchor),

            textEntryStack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 0),
            textEntryStack.topAnchor.constraint(equalTo: baseView.topAnchor, constant: space3),
            textEntryStack.trailingAnchor.constraint(equalTo: baseView.trailingAnchor, constant: 0),
            textEntryStack.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -space3),
            
            contentStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: space4),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3),
            
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        ])
    }
}
