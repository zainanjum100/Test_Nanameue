//
//  ThemeBoldLabel.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 21/06/2022.
//

import UIKit

class ThemeBoldLabel: UILabel {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        font = .systemFont(ofSize: 26, weight: .heavy)
        textColor = .appColor(.themeBlack)
    }
}

