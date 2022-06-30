//
//  ThemeTextField.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 18/06/2022.
//

import UIKit
class ThemeTextField: UIView {
    
    let leftTF: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 16)
        tf.textColor = .appColor(.themeBlack)
        tf.tintColor = .appColor(.themeBlue)
        tf.clearButtonMode = .whileEditing
        tf.textAlignment = .natural
        tf.isUserInteractionEnabled = false
        return tf
    }()
    let validationMessage: UILabel = {
        let tf = UILabel()
        tf.font = .systemFont(ofSize: 9)
        tf.textColor = .appColor(.themeBlue)
        tf.textAlignment = .center
        tf.isHidden = true
        return tf
    }()
    let separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .appColor(.themebg1)
        return separator
    }()
    let rightTF: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 16)
        tf.textColor = .appColor(.themeBlack)
        tf.tintColor = .appColor(.themeBlue)
        tf.clearButtonMode = .always
        return tf
    }()
    var accessoryImage = UIImageView()
    let borderView: UIView = {
        let separator = UIView()
        separator.backgroundColor = .appColor(.themebg1)
        return separator
    }()
    var rightSwitch: UISwitch = {
        let switchh = UISwitch()
        switchh.isOn = false
        switchh.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        switchh.isUserInteractionEnabled = true
        return switchh
    }()
    override func awakeFromNib() {
        //TF means Text Field
        setupViews()
    }
    @IBInspectable dynamic open var leftLabelText: String? {
        didSet {
            leftTF.placeholder = leftLabelText
        }
    }
    @IBInspectable dynamic open var textFieldPlaceHolder: String? {
        didSet {
            rightTF.placeholder = textFieldPlaceHolder
        }
    }
    @IBInspectable dynamic open var accessoryImg: UIImage? {
        didSet {
            accessoryImage.image = accessoryImg
            setupAccessoryImage()
        }
    }
    var validMessage: String? {
        didSet {
            if let message = validMessage{
                validationMessage.isHidden = false
                validationMessage.text = message
                if message.count == 0{
                    borderView.backgroundColor = .appColor(.themebg1)
                }else{
                    borderView.backgroundColor = .appColor(.themeBlue)
                }
                setupConstraints()
            }else{
                validationMessage.isHidden = true
                borderView.backgroundColor = .appColor(.themeGreen)
                setupConstraints()
            }
        }
    }
    @IBInspectable var isEnable: Bool = false {
        didSet {
            leftTF.isUserInteractionEnabled = isEnable
        }
    }
    @IBInspectable var isSwitch: Bool = false {
        didSet {
            if isSwitch{
                setupAccessorySwitch()
            }
        }
    }
    
    
    func setupViews() {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fill
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 10
        horizontalStackView.insertArrangedSubview(leftTF, at: 0)
        horizontalStackView.insertArrangedSubview(separatorView, at: 1)
        horizontalStackView.insertArrangedSubview(rightTF, at: 2)
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fill
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 10
        verticalStackView.insertArrangedSubview(horizontalStackView, at: 0)
        verticalStackView.insertArrangedSubview(validationMessage, at: 1)
        
        addSubview(verticalStackView)
        addSubview(borderView)
        
        addConstraintsWithFormat(format: "H:|-15-[v0]-15-|", views: verticalStackView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: borderView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: verticalStackView)
        borderView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        setupConstraints()
        
    }
    func setupAccessoryImage() {
        accessoryImage.contentMode = .scaleAspectFit
        addSubview(accessoryImage)
        addConstraintsWithFormat(format: "H:[v0(24)]-16-|", views: accessoryImage)
        accessoryImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    func setupAccessorySwitch() {
        rightTF.addSubview(rightSwitch)
        rightTF.addConstraintsWithFormat(format: "H:[v0]|", views: rightSwitch)
        rightSwitch.centerYAnchor.constraint(equalTo: rightTF.centerYAnchor).isActive = true
        
    }
    func setupConstraints() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        rightTF.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .horizontal)
        let separatorHorizonalConnnstraint = NSLayoutConstraint(item: separatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0.5)
        let separatorVerticalConnnstraint = NSLayoutConstraint(item: separatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 14)
        if let _ = validMessage{
            borderView.bottomAnchor.constraint(equalTo: validationMessage.topAnchor, constant: -5).isActive = true
        }else{
            borderView.bottomAnchor.constraint(equalTo: validationMessage.topAnchor, constant: 0).isActive = true
        }
        self.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addConstraints([separatorHorizonalConnnstraint,separatorVerticalConnnstraint])
    }
}
