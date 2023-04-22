//
//  HomescreenViewModel.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor

class HomescreenViewModel: ObservableObject {
    //@Published var postArray: [Post] = []
    @Published var post = Post()
    
    func savePost(post: Post) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = post.id {
            do {
                try await db.collection("posts").document(id).setData(post.dictionary)
                print("😎 Data upploaded successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                let documentRef = try await db.collection("posts").addDocument(data: post.dictionary)
                self.post = post
                self.post.id = documentRef.documentID
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
    
//    func savePost(post: Post) {
//        if post.id == nil {
//            var newPost = post
//            newPost.id = UUID().uuidString
//            postArray.append(newPost)
//        } else {
//            if let index = postArray.firstIndex(where: {$0.id == post.id}) {
//                postArray[index] = post
//            }
//        }
//    }
}
