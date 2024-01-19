//
//  File.swift
//
//
//  Created by Jack Young on 11/01/2024.
//

import UIKit
import Common
import RxSwift

public extension Components {
    static func baseLabel(_ text: String? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorSystem.text
        label.font = UIFont.Body.medium
        label.text = text
        return label
    }
    
    static func titleLabel(_ text: String? = nil) -> UILabel {
        let label = baseLabel(text)
        label.font = UIFont.Title.mediumBold
        return label
    }
    
    static func detailLabel(_ text: String? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = ColorSystem.secondaryText
        label.font = UIFont.Body.small
        label.text = text
        return label
    }
}
