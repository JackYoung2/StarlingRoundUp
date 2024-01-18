//
//  File.swift
//  
//
//  Created by Jack Young on 14/01/2024.
//

import UIKit
import Common

public extension Components {
    static func roundUpImage() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .red
        let poundImage = UIImage(named: "sterlingsign.circle.fill")
        let upImage = UIImage(named: "arrow.up")
        
        poundImage!.withRenderingMode(.alwaysTemplate)
        upImage!.withRenderingMode(.alwaysTemplate)
        
        let poundImageView = UIImageView(image: poundImage)
        let upImageView = UIImageView(image: upImage)
        
        poundImageView.tintColor = .systemPink
        
        poundImageView.translatesAutoresizingMaskIntoConstraints = false
        upImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(poundImageView)
        view.addSubview(upImageView)
        
        NSLayoutConstraint.activate([
                poundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                poundImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                
                upImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: space4),
                upImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
        
        return view
    }
}

public class MyCustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    private func setupUI() {
        // Create a horizontal stack view
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false


        // Create an image view for the first image
        let poundImageView = UIImageView(image: UIImage(named: "sterlingsign.circle.fill"))
//        poundImageView.setContentHuggingPriority(.required, for: .horizontal)
        view.addSubview(poundImageView)
        poundImageView.translatesAutoresizingMaskIntoConstraints = false

        // Create an image view for the second image
        let upImageView = UIImageView(image: UIImage(named: "arrow.up"))
        upImageView.translatesAutoresizingMaskIntoConstraints = false
//        upImageView.setContentHuggingPriority(.required, for: .horizontal)
//        upImageView.contentMode = .scaleAspectFit
//        upImageView.setContentCompressionResistancePriority(.required, for: .horizontal)
    
        view.addSubview(upImageView)
        

        // Set up constraints
        addSubview(view)
        NSLayoutConstraint.activate([
            
            upImageView.centerXAnchor.constraint(equalTo: poundImageView.trailingAnchor, constant: space2),
            upImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -space2),
            
            poundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            poundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            poundImageView.topAnchor.constraint(equalTo: topAnchor, constant: space2),
            poundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
