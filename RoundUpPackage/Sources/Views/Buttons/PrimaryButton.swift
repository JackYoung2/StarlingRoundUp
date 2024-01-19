//
//  File.swift
//  
//
//  Created by Jack Young on 09/01/2024.
//

import Foundation
import Common
import UIKit

public extension Components {
    
    static func createPrimaryButton(
        _ text: String,
        _ corners: Double? = nil,
        action: Selector? = nil
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        if let action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(ColorSystem.tint, for: .normal)
        button.layer.cornerRadius = corners ?? .zero
  
        
        return button
    }
    
    static func borderButton(
        _ text: String,
        _ corners: Double = space3,
        action: Selector? = nil
    ) -> UIButton {
        let button = createPrimaryButton(text, corners, action: action)
        button.layer.borderWidth = space1
        button.layer.borderColor = ColorSystem.tint.cgColor

        
        return button
    }
    
}
