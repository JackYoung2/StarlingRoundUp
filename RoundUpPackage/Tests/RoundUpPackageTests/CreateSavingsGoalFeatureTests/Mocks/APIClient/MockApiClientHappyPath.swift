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

public struct MockApiClientHappyPath: APIClientProtocol {
    var loadDataExpectation: XCTestExpectation? = nil
    var callEndpointExpectation: XCTestExpectation? = nil
    var response: URLResponse!
    var data: Data!
    var returnValue: Any
    
    public var loadData: (URLRequest) async throws -> (Data, URLResponse)
    
    public func call<Value>(_ endpoint: inout Endpoint<Value>) async throws -> Result<Value, APIError> where Value : Decodable {
        callEndpointExpectation?.fulfill()
        return .success(returnValue as! Value)
    }
    
    public init(
        loadDataExpectation: XCTestExpectation? = nil,
        callEndpointExpectation: XCTestExpectation? = nil,
        response: URLResponse? = nil,
        data: Data? = nil,
        returnValue: Any
    ) {
        self.loadData = { _ in
            loadDataExpectation?.fulfill()
            return (data ?? Data(), response ?? URLResponse.init())
        }
        
        self.loadDataExpectation = loadDataExpectation
        self.response = response
        self.data = data
        self.callEndpointExpectation = callEndpointExpectation
        self.returnValue = returnValue
    }
    
}
