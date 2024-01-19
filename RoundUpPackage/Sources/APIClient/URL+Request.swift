//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation

//extension URL {
//    func url(with queryItems: [URLQueryItem]) -> URL {
//        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
//        components.queryItems = (components.queryItems ?? []) + queryItems
//        return components.url!
//    }
//    
//    init<Value>(_ host: String, _ apiKey: String, _ endpoint: Endpoint<Value>) {
//        let queryItems = [ ("api_key", apiKey) ]
//            .map { name, value in URLQueryItem(name: name, value: "\(value)") }
//        
//        let url = URL(string: host)!
//            .appendingPathComponent(endpoint.path)
//            .url(with: queryItems)
//        
//        self.init(string: url.absoluteString)!
//    }
//}
