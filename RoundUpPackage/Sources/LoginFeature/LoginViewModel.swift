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

public typealias LoginResponse = String

public typealias LoginResult = Result<LoginResponse, APIError>

public class LoginViewModel {
    
    public var networkingDriver: Driver<Bool> { isNetworking.asDriver(onErrorJustReturn: false) }
    var isNetworking: PublishRelay<Bool> = .init()
    public let loginResultPublisher = PublishRelay<LoginResult>()
    
    public func doneButtonTapped() async throws {
        isNetworking.accept(true)
        try await Task.sleep(nanoseconds: 1000000000)
        loginResultPublisher.accept(.success(""))
        isNetworking.accept(false)
    }
    
    public init() {

    }
}
