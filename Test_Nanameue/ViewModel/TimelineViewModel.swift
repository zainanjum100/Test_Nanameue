//
//  DashboardViewModel.swift
//  Test_Nanameue
//
//  Created by Zain ul abideen on 20/06/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class TimelineViewModel {
    
    // MARK: - Variables
    // observer base MVVM
    
    // user variable to store user's data
    var user: Observer<UserModel?> = Observer(nil)
    
    // timeline posts to store all the timelineposts
    var timelinePosts: Observer<[TimelineModel]?> = Observer(nil)
    
    // MARK: - Methods
    
    // logout from firebase
    func logoutFromFirebase(completion: @escaping CompletionHandler) {
        
        // firebase auth
        let firebaseAuth = Auth.auth()
        do {
            // signout from firebase
          try firebaseAuth.signOut()
            completion(true)
        } catch let signOutError {
            // error handling
          print("Error signing out: ", signOutError)
            completion(false)
        }
    }
    
    // delete post from firebase
    func deletePost(uuid: String, completion: @escaping ((String) -> ())) {
        
        // database reference
        let database = Firestore.firestore()
        
        // collection reference
        database.collection("posts").document(uuid).delete() { err in
            if let err = err {
                completion("Error removing document: \(err)")
            } else {
                completion("Post deleted successfully")
            }
        }

    }
    
    // get user details from firebase
    
    func getuserDetails(with uuid: String) {
        
        // database reference

        let database = Firestore.firestore()
        var reference: DocumentReference? = nil

        // users reference
        reference = database.document("users/\(uuid)")
        
        reference?.addSnapshotListener({ snapshot, error in
            if let snapshot = snapshot {
                // try catch for decoding errors
                do {
                    // assigning data to user
                    self.user.value = try snapshot.data(as: UserModel.self)
                    
                } catch let error {
                    // error handling
                    print(error.localizedDescription)
                }
            }
        })
    }
    
    // fetch timeline posts from firebase
    func getTimelinePosts() {
        
        // database refence
        let database = Firestore.firestore()

        // get array of timline posts
        database.collection("posts").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                // try catch for decoding errors
                do {
                    // asigning data to timeline posts
                    self.timelinePosts.value = try snapshot.documents.compactMap{
                        // decoding data and sorting with date
                        try $0.data(as: TimelineModel.self)
                    }.sorted(by: {$0.timestamp > $1.timestamp})
                    
                    // error handling
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
