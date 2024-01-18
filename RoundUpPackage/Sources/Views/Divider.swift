//
//  File.swift
//  
//
//  Created by Jack Young on 16/01/2024.
//

import Foundation
import UIKit
import Common

public extension Components {
    static func createDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = ColorSystem.separator
        return view
    }
}
