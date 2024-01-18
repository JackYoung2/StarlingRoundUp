//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit

extension Components {
    static func createTextField() -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
