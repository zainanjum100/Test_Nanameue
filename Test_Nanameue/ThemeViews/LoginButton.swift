//
//  LoginButton.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 20/06/2022.
//

import UIKit

class ThemeRoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel?.font = .systemFont(ofSize: 22, weight: .heavy)
        setTitleColor(.appColor(.themeWhite), for: .normal)
        backgroundColor = .appColor(.themeBlue)
        cornerRadius = 5
        setTitleColor(.appColor(.themeWhite), for: .normal)
        layer.cornerRadius = 12
        clipsToBounds = true
    }
}
