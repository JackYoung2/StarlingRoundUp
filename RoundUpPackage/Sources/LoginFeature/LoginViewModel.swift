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
    let sessionManager: SessionManagerProtocol

    public init(sessionManager: SessionManagerProtocol) {
        self.sessionManager = sessionManager
    }
}
