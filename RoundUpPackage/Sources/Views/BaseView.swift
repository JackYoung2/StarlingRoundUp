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
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: Double = space3,
        distribution: UIStackView.Distribution = .equalSpacing,
        alignment: UIStackView.Alignment = .fill,
        subViews: [UIView] = []
    ) -> UIStackView {
        let view = UIStackView(arrangedSubviews: subViews)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = axis
        view.distribution = distribution
        view.spacing = spacing
        view.alignment = alignment
        return view
    }
}


