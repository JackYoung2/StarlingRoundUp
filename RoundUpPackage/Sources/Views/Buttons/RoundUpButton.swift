//
//  File.swift
//
//
//  Created by Jack Young on 14/01/2024.
//

import UIKit
import Common

public extension Components {
    
    static func roundUpButton(_ roundUpTotal: String, action: Selector? = nil) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let label = Components.baseLabel("Add \(roundUpTotal) to savings goal")
        label.textColor = ColorSystem.tint
    
        let poundImageView = UIImageView(image: UIImage(named: "sterlingsign.circle.fill"))
        button.addSubview(poundImageView)
        poundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let upImageView = UIImageView(image: UIImage(named: "arrow.up"))
        upImageView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(upImageView)
        button.addSubview(label)
        
        if let action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }

        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: poundImageView.leadingAnchor, constant: -space3),
            label.centerYAnchor.constraint(equalTo: poundImageView.centerYAnchor),
            
            upImageView.centerXAnchor.constraint(equalTo: poundImageView.trailingAnchor, constant: space2),
            upImageView.topAnchor.constraint(equalTo: button.topAnchor),
            upImageView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -space3),
            
            poundImageView.topAnchor.constraint(equalTo: button.topAnchor, constant: space2),
            poundImageView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -space3),
        ])
        
        return button
    }
}
