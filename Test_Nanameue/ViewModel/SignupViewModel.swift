//
//  SignupViewModel.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 21/06/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignupViewModel {
    
    // MARK: - Methods
    //sign up with email
    func signupWithEmailFirebase(email: String, password: String, completion: @escaping AuthResult) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(authResult,error)
        }
    }
    // Saving user's profile e.g email and fullname
    func updateUser(at uuid: String,fullName: String, email: String, completion: @escaping CompletionHandler) {
        //database reference
        let database = Firestore.firestore()
        var reference: DocumentReference? = nil
        
        //document reference to store data
        let documentRefString = database.collection("users").document(uuid)
        reference = database.document("users/\(documentRefString)")
        
        // dictionary for user data
        let userData = [
            "full_name": fullName,
            "email": email
        ]
        
        //saving data on firestore
        documentRefString.setData(userData, completion: { error in
            
            //error handling
            if let err = error {
                print("Error adding document: \(err)")
                completion(false)
            } else {
                //document added
                print("Document added with ID: \(reference!.documentID)")
                completion(true)
            }
        })
        
    }
}
