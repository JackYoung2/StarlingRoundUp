//
//  AppDelegate.swift
//  StarlingRoundUp
//
//  Created by Jack Young on 09/01/2024.
//

import UIKit
import CoreData
import TransactionFeedFeature
import KeychainClient
import APIClient
import RoundUpClient
import RxSwift
import RxCocoa
import RxRelay
import LoginFeature
import SessionManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let bag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //        MARK: - Set Up Dependencies
        let sessionManager = SessionManager()
        
        let feedViewModel = TransactionFeedViewModel(
            apiClient: APIClient(),
            route: .alert(.emptyName),
            roundUpClient: RoundUpClient(),
            sessionManager: sessionManager
        )
        
        //        MARK: - Prepare View
        let viewController = TransactionFeedViewController(viewModel: feedViewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        
        var loginViewController: LoginViewController?
        
//    MARK: - Handle Auth
        
        sessionManager
            .sessionSubject
            .observe(on: MainScheduler.instance)
            .skip(1)
            .subscribe(onNext: { session in
                if session == nil {
                    loginViewController = LoginViewController(.init(sessionManager: sessionManager))
                    loginViewController?.modalPresentationStyle = .fullScreen
                    navigationController.modalPresentationStyle = .fullScreen
                    navigationController.present(loginViewController!, animated: true)
                } else {
                    navigationController.dismiss(animated: true)
                    Task {
                        try await viewController.viewModel.fetchAccount()
                        try await viewController.viewModel.fetchTransactions()
                    }
                }
            }
            )
        
            .disposed(by: bag)
        
        window?.makeKeyAndVisible()
        
        return true
    }
}
