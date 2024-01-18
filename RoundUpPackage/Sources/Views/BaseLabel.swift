//
//  File.swift
//
//
//  Created by Jack Young on 11/01/2024.
//

import UIKit
import Common

public extension Components {
    static func baseLabel(_ text: String? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorSystem.text
        label.font = UIFont.systemFont(ofSize: space5)
        label.text = text
        return label
    }
    
    static func detailLabel(_ text: String? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorSystem.secondaryText
        label.font = UIFont.systemFont(ofSize: space4)
        label.text = text
        return label
    }
}
