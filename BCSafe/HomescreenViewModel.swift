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
    @Published var post = Post()
    @Published var annotation = Annotation()
    
    func savePost(post: Post, annotation: Annotation) async -> Bool {
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
                _ = try await db.collection("posts/\(self.post.id!)/annotations").addDocument(data: annotation.dictionary)
                print("🐣 Data added successfully!")
                return true
            } catch {
                print("😡 ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
}
