//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation
import Common

public enum APIError: Error {
    case networkError
    case parsingError
}

public protocol APIClientProtocol {
//    var decoder: JSONDecoder { get set }
    var loadData: (URLRequest) async throws -> (Data, URLResponse) { get set }
    func call<Value: Decodable>(_ endpoint: inout Endpoint<Value>) async throws -> Result<Value, APIError>
}
public struct APIClient: APIClientProtocol  {
    
    public var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.isoDateFormatter)
        return decoder
    }
    
    public var loadData: (URLRequest) async throws -> (Data, URLResponse)
    
    var dataTask: (URLRequest) async throws -> (Data, URLResponse) = { request in
        try await URLSession.shared.data(for: request)
    }
    
    
    public init(
        decoder: JSONDecoder? = nil,
        loadData: ((URLRequest) -> (Data, URLResponse))? = nil
    ) {
        self.loadData = loadData ?? dataTask
    }
    
    public func call<Value: Decodable>(_ endpoint: inout Endpoint<Value>) async throws -> Result<Value, APIError> {
        endpoint.headers["Authorization"] = "Bearer \(authToken)"
        endpoint.headers["User-Agent"] = userAgent
        
        guard let (data, _) = try? await loadData(endpoint.urlRequest()) else {
            return .failure(.networkError)
        }
        
        // TODO: - More precise Error Handling with response codes
        
        do {
            let result = try decoder.decode(Value.self, from: data)
            return .success(result)
        } catch {
            print(error)
            return .failure(.parsingError)
        }
    }
}
