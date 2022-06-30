//
//  UserModel.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 21/06/2022.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth

struct UserModel: Codable {
    @DocumentID var id: String?
    let fullName: String
    let email: String
    
    private enum CodingKeys : String, CodingKey {
        case id, fullName = "full_name", email
    }
}
