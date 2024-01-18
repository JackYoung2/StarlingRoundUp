//
//  File.swift
//  
//
//  Created by Jack Young on 18/01/2024.
//

import UIKit

public extension UITableViewCell {
    @objc static var identifier: String { return String(describing: self) }
}

//public protocol IdentifiedCell: UITableViewCell {
//    static var identifier: String { get }
//    var register: AnyClass? { get }
//}
//
//extension IdentifiedCell {
//    var register: AnyObject { Self.self }
//}
