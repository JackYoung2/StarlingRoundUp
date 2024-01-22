//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit
import Common

public extension Components {
    static func progressBar() -> UIProgressView {
        let bar = UIProgressView(progressViewStyle: .bar)
        bar.translatesAutoresizingMaskIntoConstraints = false

        bar.tintColor = ColorSystem.tint
        return bar
    }
}
