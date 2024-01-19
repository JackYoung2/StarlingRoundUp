//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation

public struct AlertState {
    public var title: String
    public var message: String
    
    public init(title: String, message: String) {
        self.title = title
        self.message = message
    }
}
