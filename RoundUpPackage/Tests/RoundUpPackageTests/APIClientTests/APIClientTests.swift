//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import XCTest
@testable import APIClient
import SharedModel
import SessionManager

class APIClientTests: XCTestCase {
    
    enum ErrorDummy: Error {
        case error
    }

    func testNetworkError_throwsCorrectError() async throws {
        let apiClient = APIClient { _ in
            throw ErrorDummy.error
        }
        
        var endpoint: Endpoint<AccountResponse> = .getAccount()
        let result = try await apiClient.call(&endpoint, token: Session.mock.token, userAgent: Session.mock.userAgent)
        XCTAssertEqual(result.error as? APIError, APIError.networkError)
    }
    
//    TODO :- Mock url response and put back
//    func testDecodeError_throwsCorrectError() async throws {
//        
//        let apiClient = APIClient { _ in
//            (try! JSONEncoder().encode(""), MockURLResponse() as URLResponse)
//        }
//        
//        var endpoint: Endpoint<AccountResponse> = .getAccount()
//        let result = try await apiClient.call(&endpoint, token: Session.mock.token, userAgent: Session.mock.userAgent)
//        XCTAssertEqual(result.error as? APIError, APIError.parsingError)
//    }
}

