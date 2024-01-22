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
public var userAgentHolder = "Jack-Young"
public let authTokenHolderValid =
"eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAA_21Ty47bMAz8lcLn5cIPJbJz660_0A-gSXojrC0Zkpztoui_V34kXgd7CTwz5JAUmb-ZCSG7ZDgaYBnca4joe2PfWrTvr-SG7CULU5siKG9OJVMN-ZkYVFl20Jy0hkKRUi2LbpoiBcufMbsUOj_npSpU-ZIZjAtxaiqtZwKJ3GTjL9ez-N-GN28q6ga4bWpQWDLUZ6nTT9uotuqoonPyju5d7JrBGrWuTzWgqk6gKnWCVhcl5A3ltc4rQqVTRhrrJ5GEsNdpSlRQampBcSVQtzqHqpCSWmpUwTwPTG6U-VHWTuG6tAoWB7l4Qf7xJMTP8UkwLDaazog_8r0J8cBsgNmnJi_CJj7AqsSIdB3kETnFq_MmpA2BsWxuhifsV63FHi1tnRB6BnI2etevvjOzac52xg8YjbPgOugmy1s9mkJ0w71tGdBs2QNaxigXll6iPOASNkjEhPBCCc7iHS-ZI36K3KUVbCYr2IPADPi2ea7a_gnRow1Ic88PGnpHafrdeyXAzc_wzG5Z3nWmv5daax-oJcoLiRnjAYSj9OFNcg94S6sI8Ob2Pg7cNuqBW3y-MutwXXr2byx28RuvXVxN6So89cKQxt6vJkiMacBp3OCI9zNJf_d0RemYnOcv5Y_sve6R_SYf3Id98FHmBoDC7ZkauVuprztdVvG85OzffzJWH7WhBAAA.ECvLZtsOmEOV0-4jDOlIVc5rjMlf1YbyUr-8k3lPEwg9Kpw3ZYM3OiNdkU2Vqtt_HTR5nFiq-MPbHsjEhUQTfI8iSk3GWWVeumDJfUZonzm__hi5-oNPy2LDQNWrbwlNsY_zy-8Ph-QkNEsJnC_xryJmkcQEdmQhvGFKe5xm9923V-uke5Q2QqNDcARqgJ8GFStT8LIGvMx4vQzB7eJuK8sn8H6-2n-7KyEMrbY8mNA2BMej3I9-DVAYZ1UVY35w3kJzIpHxLJFDBcxYjYyJf-tLHp-mj8PsA0bunKdhwMsgXyTefzcmv8PCR6XgzDfT9HRl9gkOXjHRBIx9HLLco_k3uGQA0eMuHRigeMBw_8cT2_cSCKHEzfXp_SPt4sUrJV6FrpyzNFqk6rcrnU8mcQ-LWlS3jC5vzUO2JLiH_kaUmHQmCU2GpokLgo0SkcxgoRkOQXLr_5jIVfWv_sQe_-fmuTvXexNGnyEgssMAzR4-4MormF8WxyVp16QFKIp0pPUxDuIYhLKPlkiB0LI1rBXZjgfu1H2E-TpIpb10RJY900oV08fy2jrK1jfv1RXokVTcG5Lnea3XtrhoSHQLFXwQPkeQTKCAqHgIecd7t5o5z9g_VIZn9avAMu4X6r_EaALHDPoVmsVfiD38R5WyfS-reFtlQdYOPtOED4dqgAo"
