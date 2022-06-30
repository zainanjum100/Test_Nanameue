//
//  UIButtonExtension.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 20/06/2022.
//

import UIKit
extension UIButton {
    func validBtn()  {
        self.backgroundColor = .appColor(.themeBlue)
        self.isUserInteractionEnabled = true
    }
    func inValidBtn()  {
        self.backgroundColor = .appColor(.themeLightBlue)
        self.isUserInteractionEnabled = false
    }
}
