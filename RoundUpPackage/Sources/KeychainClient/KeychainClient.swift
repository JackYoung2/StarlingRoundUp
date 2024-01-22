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

public var userAgentHolder = "Jack-Young"

public let authTokenHolderValid =
"eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21Ty47bMAz8lcLn5cKvxI9bb_2BfgBN0omwtmRIcraLov9e2XLiONhL4Jkhh6TI_E2Uc0mb4KSAZTTvzqMdlL50qD_eyYzJW-LmLkRQ2pxyphrSMzGUed5Dc6oqyEoqy46laposBMufKWmzKj2nWZMW1Vui0K_EqSny80IgkZm1_2UGFvtb8eZNWd0Ad00NJeYM9Vnq8NM1ZVf0VNA5eHvzITpmcHXKe8IC6qrIocyogholdHPqCunpjE1ehIww1k8icW6v0-RYQl5RByUXAnVXpVBkklNHTZkxLwOTmWR5lNgpXNdWQeMorRXkHy-C_5peBMWiveqV2CM_KOcPzAaYbWiyFVb-AaLiPdJ1lEfk7K_GKhc2BEqzuimecYhahwNq2johtAxktLdmiL4Ls2lG98qO6JXRYHroZ81bPZqdN-O9bRlRbdkjakYvLcsgXh5wDRvFY0DYUoCLeMdr5oRfIncpgs0kgj0I1IiXzTNq-yd4i9ohLT0_aBgMhel370iAWZ7hld2yrOnVcC8Vax-oNcoKiZr8Abij9GlVcHd4C6twcDF7HwduG_XArT7PTByuD8_-jcUufuO1i9GUrsLzIAxh7P1qnHgfBpynDU54P5Pwdw9XFI7JWH4qf2TvdY_sN_lgPvWD97I0AORur9TEfaSed7qu4nXJyb__LjLO-qEEAAA.jQD0y1peFhEbeEE6GmsG9VgJ0JdEFgXquqvrWBhEyjkg6e0Ndl8ld7HWkufgrUsboPKCm11jsqxdEIMGxzUsFPadqxafxzoFiff6YkkWAxhpXYPaxWHiQfSN92pzAI9nnE1_3OI_zYWHMMbw28yQk3pim1eWWLV-_vWPs3RrviAnvPA0taIhKbM28t11A9LuFxMtBZJ_8v0PtyYmCmHWb2sJnSIEwKAcShWmf_pkPdwZFEIe4jcqHEkhzc-Fc4EH6ZB8nCov25U6Z6-XXrew35JyyImwgF5axmmtKUMfOtoR1Dqnidx8ML7T7jVQHnZHDh6fHye-BPQ9RRzCGK6h1qkNxpR9vUcs1T05QFIeiJe2Ykp52jVLBT9xBsF-4YcobCLocWbQej93lZuAUQEX1dxH0yF0Ou0z_WIqJtDe06hwR2A6bEFoIv5genjhK2q6UGdunzCQk-yo4w9bxrj6pCjUAW4S2BrNHbjb8FXg91HbLuaW8mLHoYueVHAG4TnENCa7zJQprMpmrrswqofv7FN5mViUEkZU2og1gltVdqDgpbg6mJRg1L54k2yNJ0sO8o6vbT5ALybezh9ut8rTOWTwtCoJ95lGaTVKrZjjaCqpCsozD8LunT43uT6knyNBhOYezJYtCdQ-_zArOUyhgyha9NESpzaHa6W0Po_EmPo"
