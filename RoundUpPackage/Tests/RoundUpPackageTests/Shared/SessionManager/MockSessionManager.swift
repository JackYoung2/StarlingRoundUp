//
//  File.swift
//  
//
//  Created by Jack Young on 22/01/2024.
//

import Foundation
@testable import SessionManager


extension Session {
    static var mock = Self.init(userAgent: "Test-Agent", token: "TOKEN")
}

public struct MockSessionManager: SessionManagerProtocol {
    public func getSession() throws -> Session {
        .mock
    }
    
    public func storeSession(token: String, agent: String) throws {
        
    }
    
    public func removeSession() {
        
    }
}
