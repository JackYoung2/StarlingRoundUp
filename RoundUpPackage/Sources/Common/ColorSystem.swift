//
//  File.swift
//  
//
//  Created by Jack Young on 09/01/2024.
//

import Foundation
import UIKit

public struct ColorSystem {
    public static let primary = UIColor.blue
    public static let container = UIColor.init(resource: .init(name: "container", bundle: Bundle.module))
    public static let background = UIColor.init(resource: .init(name: "background", bundle: Bundle.module))
    public static let text = UIColor.init(resource: .init(name: "text", bundle: Bundle.module))
    public static let secondaryText = UIColor.init(resource: .init(name: "secondaryText", bundle: Bundle.module))
    public static let separator = UIColor.init(resource: .init(name: "separator", bundle: Bundle.module))
}
