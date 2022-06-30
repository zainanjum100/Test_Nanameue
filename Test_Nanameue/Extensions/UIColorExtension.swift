//
//  UIColorExts.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 18/06/2022.
//

import UIKit
extension UIColor{
    
    /// Converting hex string to UIColor
    ///
    /// - Parameter hexString: input hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
extension UIColor {
    static func appColor(_ name: AssetsColor) -> UIColor {
        return UIColor(hexString: name.rawValue)
    }
}
enum AssetsColor : String {
    
    case themeBlack = "000000"
    case themeRed = "e50914"
    case themeBlackGray = "F2F2F2"
    case themeDarkGray = "212121"
    case themeLightGray = "8b8b8b"
    case Secondary1 = "f37818"
    case themeGreen = "0cd332"
    case themeBW1 = "464646"
    case themeWhite = "FFFFFF"
    case themebg1 = "afafaf"
    case themebg2 = "e2e2e2"
    case themebg3 = "efefef"
    case themebg4 = "171717"
    case themebg5 = "242525"
    case themeLightBlue = "b3e5fc"
    case themeBlue = "#0380fc"
}
