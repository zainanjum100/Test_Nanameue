//
//  CreatePostViewModel.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 27/06/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
//full documentation
//https://firebase.google.com/docs/storage/ios/create-reference

class CreatePostViewModel {
    
    // MARK: - Variables
    // uploadTask for progress and observer in CreateViewController
    var uploadTask: Observer<StorageUploadTask?> = Observer(nil)
    
    // MARK: - Methods
    // method to upload image to firestore storage
    private func upload(image: UIImage, completion: @escaping ResultCompletion) {
        // Data in memory
        // reducing image quality
        guard let data = image.jpegData(compressionQuality: 0.6) else { return }
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()

        // Create a storage reference from our storage service
        let storageRef = storage.reference()
            
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child("PostImages/\(UUID().uuidString).jpg")
        
        // Upload the file to the path "images/rivers.jpg"
        uploadTask.value = riversRef.putData(data, metadata: nil) { (metadata, error) in
            // error handling
            if let error = error{
                completion(.failure(error))
            }
                
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                // error handling
                if let error = error{
                    // faliure case
                    completion(.failure(error))
                }else{
                    // sending download url to store in firestore database
                    completion(.success(downloadURL.absoluteString))
                }
            }
        }
        
    }
    
    // upload post with text and image is optional
    func uploadPostWith(text: String,postImage: UIImage?,userName: String, completion: @escaping ResultCompletion) {
        
        // chcking if there is an image
        if let postImage = postImage {
            // calling upload method to store image on firestore storage
            upload(image: postImage) { result in
                switch result {
                case .success(let postImageUrl):
                    // after image is successfully uploaded to firestore storage now we are storing image url with post on firestore database
                    self.uploadToFirestore(postImageUrlString: postImageUrl,userName: userName, postText: text) { result in
                        // sending result for result handling in CreateViewController
                        completion(result)
                    }
                    // error handling
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }else{
            // in this step we are just uploading post with a text and image is ignored
            self.uploadToFirestore(postImageUrlString: "",userName: userName, postText: text) { result in
                // sending result for result handling in CreateViewController
                completion(result)
            }
        }
    }
    
    func uploadToFirestore(postImageUrlString: String,userName: String, postText: String, completion: @escaping ResultCompletion) {
        guard let user = Auth.auth().currentUser else { return }
        // database reference
        let database = Firestore.firestore()
        // posts collection reference
        let documentRefString = database.collection("posts")
        // post data as [String:Any] because we are also sending date not only text
        let postData = [
            "user_id": user.uid,
            "image_urlString": postImageUrlString,
            "post_text": postText,
            "user_name": userName,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String: Any]
        
        // saving data to database
        documentRefString.addDocument(data: postData) { error in
            // error handling
            if let error = error{
                completion(.failure(error))
            }else{
                // success case
                completion(.success("Successfully posted post"))
            }
        }
    }
}


