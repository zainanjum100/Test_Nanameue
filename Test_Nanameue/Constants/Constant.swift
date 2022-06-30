//
//  Constant.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 21/06/2022.
//

import Foundation
import FirebaseAuth

typealias CompletionHandler =  ((Bool) -> ())
typealias AuthResult = (AuthDataResult?, Error?) ->()
typealias ResultCompletion = (Result<String,Error>) -> ()
