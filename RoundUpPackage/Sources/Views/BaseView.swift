//
//  File.swift
//  
//
//  Created by Jack Young on 09/01/2024.
//

import Foundation
import UIKit
import Common



public extension Components {
    static func createBaseContainerView(
        _ corners: Double? = nil
    ) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = ColorSystem.container
        view.layer.cornerRadius = corners ?? space3
        return view
    }
    
    static func createStackView(
        _ axis: NSLayoutConstraint.Axis? = nil,
        _ spacing: Double? = nil
    ) -> UIStackView {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = ColorSystem.background
        view.axis = axis ?? .horizontal
        view.spacing = spacing ?? space3
        return view
    }
}


