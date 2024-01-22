//
//  File.swift
//
//
//  Created by Jack Young on 22/01/2024.
//

import Foundation
import TransactionFeedFeature
import RxRelay
import LoginFeature
import RxSwift
import SessionManager

class AppViewModel: ObservableObject {
    
    enum Route {
        case login
        case feed
    }
    
    var loginViewModel: LoginViewModel
    var feedViewModel: BehaviorRelay<TransactionFeedViewModel>
    var route: BehaviorRelay<AppViewModel.Route?>
    let disposeBag = DisposeBag()
    let sessionManager: SessionManager
    
    init(
        loginViewModel: LoginViewModel,
        feedViewModel: TransactionFeedViewModel,
        route: AppViewModel.Route? = nil,
        sessionManager: SessionManager
    ) {
        self.loginViewModel = loginViewModel
        self.feedViewModel = BehaviorRelay(value: feedViewModel)
        self.route = BehaviorRelay(value: route)
        self.sessionManager = sessionManager
        subscribe()
    }
    
    func subscribe() {
        loginViewModel
            .loginResultPublisher
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.route.accept(.feed)
            }
            .disposed(by: disposeBag)
    }
}

extension AppViewModel.Route: Equatable {
    public static func == (
        lhs: AppViewModel.Route,
        rhs: AppViewModel.Route
    ) -> Bool {
        switch (lhs, rhs) {
        case (.feed, .feed):
            return true
            
        case (.login, .login):
            return true
            
        default:
            return false
        }
    }
}

