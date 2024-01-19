//
//  File.swift
//  
//
//  Created by Jack Young on 19/01/2024.
//

import SwiftUI

public struct ToSwiftUI: UIViewControllerRepresentable {
    public let viewController: () -> UIViewController
    
    public init(viewController: @escaping () -> UIViewController) {
        self.viewController = viewController
    }
    
    public func makeUIViewController(context: Context) -> UIViewController {
        self.viewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
