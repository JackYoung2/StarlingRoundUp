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
        action: Selector
    ) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(ColorSystem.text, for: .normal)
        button.layer.cornerRadius = corners ?? .zero

        
        return button
    }
    
}
