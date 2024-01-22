//
//  File.swift
//  
//
//  Created by Jack Young on 20/01/2024.
//

import UIKit
import Common

public extension Components {
    static func roundUpButtonImage() -> UIImageView {
        let upImageView = UIImageView(image: UIImage(named: "arrow.up"))
        upImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let poundImageView = UIImageView(image: UIImage(named: "sterlingsign.circle.fill"))
        poundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        poundImageView.addSubview(upImageView)
        
        NSLayoutConstraint.activate([
            upImageView.leadingAnchor.constraint(equalTo: poundImageView.trailingAnchor, constant: -space2),
            upImageView.bottomAnchor.constraint(equalTo: poundImageView.centerYAnchor, constant: 0)
        ])
        
        return poundImageView
    }
}
