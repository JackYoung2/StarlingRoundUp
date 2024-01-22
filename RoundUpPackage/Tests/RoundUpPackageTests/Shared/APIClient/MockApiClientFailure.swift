//
//  File.swift
//  
//
//  Created by Jack Young on 21/01/2024.
//

import Foundation
import APIClient
import XCTest
@testable import AppFeature

public struct MockApiClientFailure: APIClientProtocol {
    var loadDataExpectation: XCTestExpectation? = nil
    var callEndpointExpectation: XCTestExpectation? = nil
    var response: URLResponse?
    var data: Data?
    var error: APIError
    
    public var loadData: (URLRequest) async throws -> (Data, URLResponse)
    
    public func call<Value>(_ endpoint: inout Endpoint<Value>, token: String, userAgent: String) async throws -> Result<Value, APIError> where Value : Decodable {
        callEndpointExpectation?.fulfill()
        return .failure(error)
    }
    
    public init(
        loadDataExpectation: XCTestExpectation? = nil,
        callEndpointExpectation: XCTestExpectation? = nil,
        response: URLResponse? = nil,
        data: Data? = nil,
        error: APIError
    ) {
        self.loadData = { _ in
            loadDataExpectation?.fulfill()
            return (data ?? Data(), response ?? URLResponse.init())
        }
        
        self.loadDataExpectation = loadDataExpectation
        self.response = response
        self.data = data
        self.callEndpointExpectation = callEndpointExpectation
        self.error = error
    }
    
}
