//
//  File.swift
//  
//
//  Created by Jack Young on 16/01/2024.
//

import Foundation
import UIKit
import Common

public extension Components {
    static func createDivider() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.backgroundColor = ColorSystem.separator
        return view
    }
}

//public class DividerView: UIView {
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        commonInit()
//    }
//
//    private func commonInit() {
//        backgroundColor = ColorSystem.background
//        self.
//    }
//
//    public override var intrinsicContentSize: CGSize {
//        return CGSize(width: UIView.noIntrinsicMetric, height: 1.0)
//    }
//}
