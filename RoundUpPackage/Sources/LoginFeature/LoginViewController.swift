//
//  File.swift
//  
//
//  Created by Jack Young on 22/01/2024.
//

import UIKit
import Views
import Common
import RxSwift
import RxCocoa

public class LoginViewController: UIViewController {
    
//    MARK: - Dependencies
    var viewModel: LoginViewModel
    let disposeBag = DisposeBag()
    
    //    MARK: - View Components
    let contentStack = Components.createStackView(axis: .vertical, spacing: space5, distribution: .fill, alignment: .fill)
    let titleLabel = Components.titleLabel("Welcome to RoundUp!")
    let instructionLabel = Components.detailLabel("The App is currently unauthorised, please see the README to get started")
    
    //    MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public init(
        _ viewModel: LoginViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//    MARK: - setUpView
extension LoginViewController {

    func setUpView() {
        self.view.backgroundColor = ColorSystem.background
        
        titleLabel.textAlignment = .center
        instructionLabel.textAlignment = .center
        instructionLabel.numberOfLines = 0
        
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(instructionLabel)
        
        view.addSubview(contentStack)
        
        
        NSLayoutConstraint.activate([
            contentStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: space3),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -space3)
        ])
    }
}
