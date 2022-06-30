//
//  LoginViewModel.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 20/06/2022.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    // login with firebase
    func loginWithEmailFirebase(email: String, password: String, completion: @escaping AuthResult) {
        // login with email and password
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            completion(authResult,error)
        }
    }
    
}
