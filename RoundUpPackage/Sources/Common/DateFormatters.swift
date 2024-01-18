//
//  File.swift
//  
//
//  Created by Jack Young on 11/01/2024.
//

import Foundation


//public func getTodayWeekDay(_ date: Date) -> String {
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "EEEE"
//    let weekDay = dateFormatter.string(from: date).lowercased()
//    return weekDay
//}

public extension DateFormatter {
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    static let relativeDateFormatter: DateFormatter = {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "en_GB")
        relativeDateFormatter.doesRelativeDateFormatting = true
        return relativeDateFormatter
    }()
}


public extension Date {
    var asTimeString: String? {
        DateFormatter.timeFormatter.string(from: self)
    }
    
    var relativeDate: String? {
        DateFormatter.relativeDateFormatter.string(from: self)
    }
}
