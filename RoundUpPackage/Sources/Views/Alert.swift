//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import UIKit
import Common

public extension Components {
    static func alert(state: AlertState) -> UIAlertController {
        let alert = UIAlertController(title: state.title, message: state.message, preferredStyle: .alert)
        return alert
    }
}
