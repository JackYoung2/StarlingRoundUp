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
import LoginFeature
import SessionManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var keyChainClient: KeychainClient = .live
    
//    let feedViewModel = TransactionFeedViewModel(
//        apiClient: APIClient(),
//        roundUpClient: RoundUpClient()
//    )
    
//    lazy var loginViewModel = LoginViewModel()
//    
//    lazy var appViewModel: AppViewModel = .init(
//        loginViewModel: loginViewModel,
//        feedViewModel: TransactionFeedViewModel(
//        apiClient: APIClient(),
//        roundUpClient: RoundUpClient(), 
//        sessionManager: .init()
//    ),
//        route: .login)
////    enum Route
////    
//    public var route: BehaviorRelay<Route?>
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        
        let feedViewModel = TransactionFeedViewModel(
            apiClient: APIClient(),
            roundUpClient: RoundUpClient(),
            sessionManager: SessionManager()
        )
        
        let viewController = TransactionFeedViewController(viewModel: feedViewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        
        
        window?.makeKeyAndVisible()
        
//        appViewModel
//            .route
//            .subscribe { route in
//            switch route {
//            case .feed:
//                let viewController = TransactionFeedViewController(viewModel: self.appViewModel.feedViewModel.value)
//                let navigationController = viewController
//                self.window?.rootViewController = navigationController
//            case .login:
//                self.window?.rootViewController = LoginViewController(.init())
////                navigationController.modalPresentationStyle = .overCurrentContext
////                navigationController.present(LoginViewController(), animated: true)
//            default:break
//            }
//        }
//        .disposed(by: disposeBag)
//        
        
        
        
        
        return true
    }
}
