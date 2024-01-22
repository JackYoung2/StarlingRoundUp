//
//  File.swift
//  
//
//  Created by Jack Young on 22/01/2024.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import APIClient
import SessionManager

public class LoginViewModel {
    
    public var networkingDriver: Driver<Bool> { isNetworking.asDriver(onErrorJustReturn: false) }
    var isNetworking: PublishRelay<Bool> = .init()
    let sessionManager: SessionManager
    
    public func loginButtonTapped() async throws {
        isNetworking.accept(true)
        try await Task.sleep(nanoseconds: 1000000000)
        
        let session = Session.test
        self.sessionManager.sessionSubject.accept(session)
        isNetworking.accept(false)
    }
    
    public init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }
}
