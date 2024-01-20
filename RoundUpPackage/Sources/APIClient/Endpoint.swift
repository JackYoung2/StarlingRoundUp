//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation

public struct Endpoint<Decodable> {
    let baseUrl = "api-sandbox.starlingbank.com"
    let path: String
    let queryItems: [URLQueryItem]
    let method: HTTPMethod
    var headers: [String: String]
    var body: Data?

    public init(
         path: String,
         queryItems: [URLQueryItem] = [],
         method: HTTPMethod = .get,
         headers: [String: String] = ["Accept": "application/json"],
         body: Data? = nil
    ) {
        self.path = path
        self.queryItems = queryItems
        self.method = method
        self.headers = headers
        self.body = body
    }

    func urlRequest() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = baseUrl
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else { preconditionFailure("Invalid URL components") }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
    
    mutating func updateHeader(with key: String, value: String) {
        headers[key] = value
     }
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}
