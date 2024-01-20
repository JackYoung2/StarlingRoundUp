//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import Foundation


public extension Date {
    static var now = Date()
    static var yesterday: Date {
        Date.now.addingTimeInterval(-86400)
    }
    
    static var distantPast: Date {
        Date.now.addingTimeInterval(-186400)
    }
    
    static var oneWeekAgo: Self {
        let today = Date()
        guard let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian),
        let lastWeek = cal.date(
            byAdding: NSCalendar.Unit.day, value: -7, to: today, options: NSCalendar.Options.matchLast
        ) else {
            preconditionFailure("Date Format is wrong")
        }
        return lastWeek
    }
}
