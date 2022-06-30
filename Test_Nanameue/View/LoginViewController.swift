//
//  ViewController.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 17/06/2022.
//

import UIKit
import ZainSPM
class LoginViewController: UIViewController {
    
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: ThemeTextField!
    @IBOutlet weak var passwordTextField: ThemeTextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    // MARK: - Variables
    var viewModel = LoginViewModel()
    var isValidEmail = false
    var isValidPassword = false
    
    // MARK: - ViewController Life Cycle
    // Load Views
    override func loadView() {
        super.loadView()
        // setting up ui
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // make login button disable for validations
        loginButton.inValidBtn()
    }
    
    // MARK: - Methods
    func setupUI() {
        // setting signup button disable by default because of validation
        loginButton.inValidBtn()
        
        // setting up email textfield attributes
        emailTextField.rightTF.keyboardType = .emailAddress
        emailTextField.rightTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // setting up password textfield attributes
        passwordTextField.rightTF.isSecureTextEntry = true
        passwordTextField.rightTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    // method for validation
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        switch textField {
            
        case emailTextField.rightTF:
            // updating isValidEmail variable based on isValidEmail() method
            // isValidEmail() method with regex for email validation
            isValidEmail = emailTextField.rightTF.text!.isValidEmail()
            emailTextField.validMessage = isValidEmail ? nil : "Invalid email"
            
        case passwordTextField.rightTF:
            // updating isValidPassword variable based on password length
            isValidPassword = passwordTextField.rightTF.text!.count > 5
            passwordTextField.validMessage = isValidPassword ? nil : "Minimum password length is 6 characters"
            
        default:
            break
        }
        
        // calling validation method to check if all the flags are true so we can enable or disable signup button
        validation()
    }
    
    func validation()  {
        // checking if all the flags are true
        if isValidPassword && isValidEmail {
            // setting signup status clickable
            loginButton.validBtn()
        }else {
            // diabling signup button
            loginButton.inValidBtn()
        }
    }
    
    // method for signup button click action
    @IBAction func loginButtonTapped() {
        // checking safe unwrapping email and password textfield
        guard let email = emailTextField.rightTF.text,
              let password = passwordTextField.rightTF.text
        else { return }
        
        // startActivityIndicator is a method for starting loading on screen
        startActivityIndicator()
        
        // setting signup button disable to limit user to not call api when an api is already being called
        loginButton.inValidBtn()
        
        // calling viewModel method for creating a user
        viewModel.loginWithEmailFirebase(email: email, password: password) { [weak self] authResult, error in
            
            // handing strong self reffrence
            guard let strongSelf = self else { return }
            
            // checking if there is a user in the response
            if authResult?.user != nil {
                // setting root viewcontroller to dashboard if there a user
                let vc = TimelineViewController()
                
                let navigationController = UINavigationController(rootViewController: vc)
                
                if let window = UIApplication.shared.keyWindow{
                    window.rootViewController = navigationController
                }
            }
            
            // if there is an error than show it on alert
            if let error = error {
                // method for showing a simple alert
                strongSelf.showAlert(text: error.localizedDescription)
            }
            
            // calling method to stop loading
            strongSelf.stopActivityIndicator()
            
            // setting signup button clickable after the api is fisnish calling
            strongSelf.loginButton.validBtn()
        }
        
    }
    
}

