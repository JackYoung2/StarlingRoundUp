//
//  File.swift
//
//
//  Created by Jack Young on 14/01/2024.
//

import UIKit
import Common

public extension Components {
    
    static func roundUpButton(action: Selector? = nil, target: Any? = nil) -> RoundUpButton {
        let button = RoundUpButton(action: action, target: target)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

public class RoundUpButton: UIButton {
    
    public let label = Components.baseLabel()
    public let roundUpImage = Components.roundUpButtonImage()

    init(action: Selector? = nil, target: Any? = nil) {
        super.init(frame: .zero)
        setUpView(action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(action: Selector? = nil, target: Any? = nil) {
        label.textColor = ColorSystem.tint
        self.addSubview(label)
        self.addSubview(roundUpImage)
        
        if let action {
            self.addTarget(target, action: action, for: .touchUpInside)
        }
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: roundUpImage.leadingAnchor, constant: -space3),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            roundUpImage.topAnchor.constraint(equalTo: self.topAnchor),
            roundUpImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -space3),
        ])
    }
}
