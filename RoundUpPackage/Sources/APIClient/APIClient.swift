//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation
import Common

public enum APIError: Error, Equatable {
    case networkError
    case parsingError
    case noToken
    case tokenExpired
    case badRequest
    case serverError
    case genericError(Int)
}

public protocol APIClientProtocol {
    var loadData: (URLRequest) async throws -> (Data, URLResponse) { get set }
    func call<Value: Decodable>(
        _ endpoint: inout Endpoint<Value>,
        token: String,
        userAgent: String
    ) async throws -> Result<Value, APIError>
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
        loadData: ((URLRequest) async throws -> (Data, URLResponse))? = nil
    ) {
        self.loadData = loadData ?? dataTask
    }
    
    public func call<Value: Decodable>(
        _ endpoint: inout Endpoint<Value>,
        token: String,
        userAgent: String
    ) async throws -> Result<Value, APIError> {
        endpoint.headers["Authorization"] = "Bearer \(token)"
        endpoint.headers["User-Agent"] = userAgent
        
        guard let (data, response) = try? await loadData(endpoint.urlRequest()) else {
            return .failure(.networkError)
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200...209:
                do {
                    let result = try decoder.decode(Value.self, from: data)
                    return .success(result)
                } catch {
                    print(error)
                    return .failure(.parsingError)
                }
                
            case 401, 403:
                if let error = try? decoder.decode(ErrorResponse.self, from: data) {
                    if error.error == .invalidToken {
                        return .failure(APIError.tokenExpired)
                    }
                } else {
                    fallthrough
                }
                
            case 400...409:
                return .failure(.badRequest)
            default:
                return .failure(.genericError(httpResponse.statusCode))
            }
        }
        
        return .failure(.networkError)
    }
}
