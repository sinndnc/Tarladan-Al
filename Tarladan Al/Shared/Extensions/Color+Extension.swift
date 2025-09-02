//
//  Color+Extension.swift
//  Tarladan Al
//
//  Created by Sinan Dinç on 8/14/25.
//

import SwiftUICore

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
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    
    // MARK: Ana Sistem Renkleri
    static var myPrimary: Color {
        Color("Primary")
    }
    
    static var mySecondary: Color {
        Color("Secondary")
    }
    
    static var myBackground: Color {
        Color("Background")
    }
    
    static var mySurface: Color {
        Color("Surface")
    }
    
    static var myBackgroundSecondary: Color {
        Color("BackgroundSecondary")
    }
    
    // MARK: Metin Renkleri
    static var myTextPrimary: Color {
        Color("TextPrimary")
    }
    
    static var myTextSecondary: Color {
        Color("TextSecondary")
    }
    // MARK: Durum Renkleri
    static var mySuccess: Color {
        Color("Success")
    }
    static var myWarning: Color {
        Color("Warning")
    }
    
    static var myError: Color {
        Color("Error")
    }
    
    static var myInfo: Color {
        Color("Info")
    }
}
