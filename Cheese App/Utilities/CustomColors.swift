//
//  CustomColors.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/3/24.
//

import Foundation

import UIKit

import SwiftUI

struct CustomColors {
    static let background = Color(hex: AppConfig.tan)
    static let textColor = Color(hex: AppConfig.tan3)
    static let tan1 = Color(hex: AppConfig.tan1)
    static let tan2 = Color(hex: AppConfig.tan2)
    static let button = Color(hex: AppConfig.tan1)
    static let input = Color(hex: AppConfig.tan1)

}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


extension UIColor {
    convenience init(hex: String) {
        // Remove hash if it exists
        let cleanedHex = hex.replacingOccurrences(of: "#", with: "")
        
        // Get the RGB values
        var rgb: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
