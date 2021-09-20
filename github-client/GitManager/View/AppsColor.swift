//
//  AppsColor.swift
//  GitManager
//
//  Created by Aleksei Sergeev on 06.09.2021.
//

import UIKit

struct AppsColor {
    static let blue     = UIColor(rgb: 0x4078C0, alpha: 1.0)
    static let green    = UIColor(rgb: 0x6CC644, alpha: 1.0)
    static let red      = UIColor(rgb: 0xBD2C00, alpha: 1.0)
    static let orange   = UIColor(rgb: 0xC9510C, alpha: 1.0)
    static let purple   = UIColor(rgb: 0x6E5494, alpha: 1.0)
    static let white    = UIColor(rgb: 0xFAFAFA, alpha: 1.0)
    static let gray     = UIColor(rgb: 0xF5F5F5, alpha: 1.0)
    static let darkGray = UIColor(rgb: 0x404040, alpha: 1.0)
    static let black    = UIColor(rgb: 0x030303, alpha: 1.0)
}

extension UIColor {
    convenience init(rgb: Int, alpha: CGFloat) {
        let red     = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green   = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue    = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: alpha)
   }
}
