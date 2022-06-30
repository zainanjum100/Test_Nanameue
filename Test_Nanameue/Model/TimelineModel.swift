//
//  TimelineModel.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 28/06/2022.
//

import Foundation
import FirebaseFirestoreSwift

struct TimelineModel: Codable {
    @DocumentID var id: String?
    private let imageUrlString: String
    let postText: String
    let userId: String
    let userName: String
    let timestamp: Date
    var imageUrl: URL?{
        return URL(string: imageUrlString)
    }
    
    private enum CodingKeys : String, CodingKey {
        case id,imageUrlString = "image_urlString", postText = "post_text", userId = "user_id", userName = "user_name", timestamp
    }
}
