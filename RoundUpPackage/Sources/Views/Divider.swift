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
    static func createDivider(_ height: CGFloat = 1) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        view.backgroundColor = ColorSystem.separator
        return view
    }
}
