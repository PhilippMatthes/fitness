//
//  Colors.swift
//  fitness-ios
//
//  Created by Philipp Matthes on 15.10.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    
    static let all = [
        UIColor(rgb: 0xeb3b5a),
        UIColor(rgb: 0xfa8231),
        UIColor(rgb: 0xf7b731),
        UIColor(rgb: 0x20bf6b),
        UIColor(rgb: 0x0fb9b1),
        UIColor(rgb: 0x45aaf2),
        UIColor(rgb: 0x4b7bec),
        UIColor(rgb: 0xa55eea),
    ]
    
    static func colorFor(number: Int) -> UIColor {
        return all[number % all.count]
    }
    
}

extension UIColor {
    /// Usage: UIColor(rgb: 0xFFFFFF, alpha: 1.0)
    convenience init(rgb: Int) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF)/255,
            green: CGFloat((rgb >> 8) & 0xFF)/255,
            blue: CGFloat(rgb & 0xFF)/255,
            alpha: 1.0
        )
    }
}
