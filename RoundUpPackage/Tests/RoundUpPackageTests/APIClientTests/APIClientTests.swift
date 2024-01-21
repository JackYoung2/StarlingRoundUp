//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import XCTest
@testable import APIClient
import SharedModel

class APIClientTests: XCTestCase {
    
    enum ErrorDummy: Error {
        case error
    }

    func testNetworkError_throwsCorrectError() async throws {
        let apiClient = APIClient { _ in
            throw ErrorDummy.error
        }
        
        var endpoint: Endpoint<AccountResponse> = .getAccount()
        let result = try await apiClient.call(&endpoint)
        XCTAssertEqual(result.error as? APIError, APIError.networkError)
    }
    
    func testDecodeError_throwsCorrectError() async throws {
        let apiClient = APIClient { _ in
            (try! JSONEncoder().encode(""), URLResponse.init())
        }
        
        var endpoint: Endpoint<AccountResponse> = .getAccount()
        let result = try await apiClient.call(&endpoint)
        XCTAssertEqual(result.error as? APIError, APIError.parsingError)
    }
}

