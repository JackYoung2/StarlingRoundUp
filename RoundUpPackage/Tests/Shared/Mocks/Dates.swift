//
//  File.swift
//  
//
//  Created by Jack Young on 20/01/2024.
//

import Foundation

static var now = Date()

static var yesterday: Date {
    Date.now.addingTimeInterval(-86400)
}

static var distantPast: Date {
    Date.now.addingTimeInterval(-186400)
}
