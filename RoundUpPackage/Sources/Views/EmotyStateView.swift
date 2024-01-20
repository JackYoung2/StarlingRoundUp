//
//  File.swift
//  
//
//  Created by Jack Young on 20/01/2024.
//

import UIKit
import Common

public extension Components {
    static func emptyStateView(text: String) -> UIView {
        let emptyStatebaseView = Components.createBaseContainerView()
        let emptyStatelabel = Components.baseLabel(text)
        
        emptyStatebaseView.addSubview(emptyStatelabel)
        emptyStatelabel.textAlignment = .center
        emptyStatebaseView.addSubview(emptyStatelabel)
        emptyStatelabel.numberOfLines = 0
        
        NSLayoutConstraint.activate([
        emptyStatelabel.leadingAnchor.constraint(equalTo: emptyStatebaseView.leadingAnchor, constant: space3),
        emptyStatelabel.topAnchor.constraint(equalTo: emptyStatebaseView.topAnchor, constant: space3),
        emptyStatelabel.trailingAnchor.constraint(equalTo: emptyStatebaseView.trailingAnchor, constant: -space3),
        emptyStatelabel.bottomAnchor.constraint(equalTo: emptyStatebaseView.bottomAnchor, constant: -space3),
        ])
        
        return emptyStatebaseView
    }
}
