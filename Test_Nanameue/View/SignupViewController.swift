//
//  SignupViewController.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 17/06/2022.
//

import UIKit
import FirebaseAuth
class SignupViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var fullNameTextField: ThemeTextField!
    @IBOutlet weak var emailTextField: ThemeTextField!
    @IBOutlet weak var passwordTextField: ThemeTextField!
    @IBOutlet weak var confirmPasswordTextField: ThemeTextField!
    @IBOutlet weak var signupButton: UIButton!
    
    // MARK: - Variables
    var viewModel = SignupViewModel()
    var isValidFullName = false
    var isValidEmail = false
    var isValidPassword = false
    var isValidConfirmPassword = false
    
    // MARK: - Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    // loading views
    override func loadView() {
        super.loadView()
        setupUI()
    }
    
    // MARK: - Methods
    func setupUI() {
        // setting signup button disable by default because of validation
        signupButton.inValidBtn()
        
        // setting up email textfield attributes
        emailTextField.rightTF.keyboardType = .emailAddress
        emailTextField.rightTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // setting up password textfield attributes
        fullNameTextField.rightTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // setting up password textfield attributes
        passwordTextField.rightTF.isSecureTextEntry = true
        passwordTextField.rightTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // setting up confirm password textfield attributes
        confirmPasswordTextField.rightTF.isSecureTextEntry = true
        confirmPasswordTextField.rightTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    // close button action for dismissing ViewController
    @IBAction func closeButtonTapped() {
        dismiss(animated: true)
    }
    
    // method for validation
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch textField {
            
        case emailTextField.rightTF:
            // updating isValidEmail variable based on isValidEmail() method
            // isValidEmail() method with regex for email validation
            isValidEmail = emailTextField.rightTF.text!.isValidEmail()
            emailTextField.validMessage = isValidEmail ? nil : "Invalid email"
            
        case fullNameTextField.rightTF:
            // updating isValidFullName variable based on full name length
            isValidFullName = fullNameTextField.rightTF.text!.count > 2
            fullNameTextField.validMessage = isValidFullName ? nil : "Minimum full name length is 2 characters"
            
        case passwordTextField.rightTF:
            // updating isValidPassword variable based on password length
            isValidPassword = passwordTextField.rightTF.text!.count > 5
            passwordTextField.validMessage = isValidPassword ? nil : "Minimum password length is 6 characters"
            
        case confirmPasswordTextField.rightTF:
            // updating isValidConfirmPassword variable based on password and confirm password
            isValidConfirmPassword = confirmPasswordTextField.rightTF.text == passwordTextField.rightTF.text
            confirmPasswordTextField.validMessage = isValidConfirmPassword ? nil : "Password and confirm password does not match"
            
        default:
            break
        }
        
        // calling validation method to check if all the flags are true so we can enable or disable signup button
        validation()
    }
    
    func validation()  {
        // checking if all the flags are true
        if isValidPassword && isValidEmail && isValidConfirmPassword && isValidFullName{
            // setting signup status clickable
            signupButton.validBtn()
        }else {
            // diabling signup button
            signupButton.inValidBtn()
        }
    }
    
    // method for signup button click action
    @IBAction func signupButtonTapped() {
        // checking safe unwrapping email and password textfield
        guard let email = emailTextField.rightTF.text,
              let password = passwordTextField.rightTF.text,
              let fullName = fullNameTextField.rightTF.text
        else { return }
        
        // startActivityIndicator is a method for starting loading on screen
        startActivityIndicator()
        
        // setting signup button disable to limit user to not call api when an api is already being called
        signupButton.inValidBtn()
        
        // calling viewModel method for creating a user
        viewModel.signupWithEmailFirebase(email: email, password: password) { [weak self] authResult, error in
            
            // handing strong self reffrence
            guard let strongSelf = self else { return }
            
            // checking if there is a user in the response
            if let user = authResult?.user {
                
                strongSelf.viewModel.updateUser(at: user.uid, fullName: fullName, email: email) { [weak self] completion in
                    guard let strongSelf = self else { return }
                    if completion{
                        strongSelf.setRootTimelineViewController()
                    }
                    // calling method to stop loading
                    strongSelf.stopActivityIndicator()
                    
                    // setting signup button clickable after the api is fisnish calling
                    strongSelf.signupButton.validBtn()
                }
            }
            
            // if there is an error than show it on alert
            if let error = error {
                // method for showing a simple alert
                strongSelf.showAlert(text: error.localizedDescription)
            }
            
            
        }
        
    }
}
