//
//  File.swift
//
//
//  Created by Jack Young on 22/01/2024.
//

import KeychainClient
import RxSwift
import RxRelay

public struct Session {
    public var userAgent: String
    public var token: String
}

public extension Session {
    static var test = Self.init(userAgent: userAgentHolder, token: authTokenHolderValid)
}

public class SessionManager {
    
    let keychainClient = KeychainClient.test
    
    public let sessionSubject: BehaviorRelay<Session?> = .init(value: nil)
    let bag = DisposeBag()
    
    
    
    public func getSession() throws -> Session {
        let authToken = try keychainClient.get(.authToken)
        let userAgent = try keychainClient.get(.userAgent)
        return Session(userAgent: userAgent, token: authToken)
    }
    
    public func storeSession(
        token: String,
        agent: String
    ) throws {
        try keychainClient.set(.authToken, token)
        try keychainClient.set(.userAgent, agent)
    }
    
    public func removeSession() {
        sessionSubject.accept(nil)
    }
    
    public init() {
        sessionSubject.subscribe { [weak self] _ in
            do {
                try self?.keychainClient.remove(.authToken)
                try self?.keychainClient.remove(.userAgent)
            } catch {
                print("Warning, expired session was not removed")
            }
            
        }.disposed(by: bag)
    }
}
