//
//  Color+F1TV.swift
//  F1TV
//
//  Created by Ken Pham on 6/27/21.
//  Copyright © 2021 Phez Technologies. All rights reserved.
//

import SwiftUI

extension Color {
    init? (hex: String) {
        guard let color = UIColor(hex: hex) else { return nil }
        self.init(color)
    }
    
    static let backgroundColor = Color("BackgroundColor")
    static let primaryColor = Color("PrimaryColor")
    static let accentColor = Color("AccentColor")
}

extension UIColor {
    public convenience init? (hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...]) + "ff"

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}
