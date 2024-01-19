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

    init(action: Selector? = nil, target: Any? = nil) {
        super.init(frame: .zero)
        setUpView(action: action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(action: Selector? = nil, target: Any? = nil) {
        label.textColor = ColorSystem.tint
        
        let upImageView = UIImageView(image: UIImage(named: "arrow.up"))
        upImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let poundImageView = UIImageView(image: UIImage(named: "sterlingsign.circle.fill"))
        poundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(poundImageView)
        self.addSubview(upImageView)
        self.addSubview(label)
        
        if let action {
            self.addTarget(target, action: action, for: .touchUpInside)
        }
        
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: poundImageView.leadingAnchor, constant: -space3),
            label.centerYAnchor.constraint(equalTo: poundImageView.centerYAnchor),
            
            upImageView.centerXAnchor.constraint(equalTo: poundImageView.trailingAnchor, constant: space2),
            upImageView.topAnchor.constraint(equalTo: self.topAnchor),
            upImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -space3),
            
            poundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: space2),
            poundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -space3),
        ])
    }
}
