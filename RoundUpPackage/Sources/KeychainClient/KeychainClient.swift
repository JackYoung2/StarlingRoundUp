//
//  File.swift
//  
//
//  Created by Jack Young on 22/01/2024.
//

import Foundation
import Foundation
import KeychainAccess

enum KeychainError: Error {
    case emptyResult
}

public struct KeychainClient {
    public var get: (_ key: Field) throws -> String
    public var set: (_ key: Field, _ value: String) throws -> Void
    public var remove: (_ key: Field) throws -> Void
    
    public init(
        get: @escaping (_: Field) throws -> String,
        set: @escaping (_: Field, _: String) throws-> Void,
        remove: @escaping (_: Field) throws -> Void
    ) {
        self.get = get
        self.set = set
        self.remove = remove
    }

    public enum Field: String {
        case authToken, userAgent
    }
}

public extension KeychainClient {
    static let live = Self.init(
        get: { key in
            guard let value = try Keychain().get(key.rawValue) else {
                throw KeychainError.emptyResult
            }
            return value
        },
        set: { key, value in
            try Keychain().set(value, key: key.rawValue)
        },
        remove: { key in
            try Keychain().remove(key.rawValue)
        }
    )
    
    static let test = Self.init(
        get: { key in
            switch key {
            case .authToken:
                return authTokenHolderValid
            case .userAgent:
                return userAgentHolder
            }
        },
        set: { key, value in
           
        },
        remove: { key in
           
        }
    )
}

// Enter auth info here
public var userAgentHolder = ""
public let authTokenHolderValid = ""
