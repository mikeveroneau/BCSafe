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
                let subcollectionRef = db.collection("posts").document(id).collection("annotations")
                let snapshot = try await subcollectionRef.getDocuments()
                if !snapshot.isEmpty {
                    print("Already an annotation")
                } else {
                    _ = try await subcollectionRef.addDocument(data: annotation.dictionary)
                    print("Re-added annotation")
                }
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
    
    func deletePost(post: Post) async -> Bool {
        let db = Firestore.firestore()
        guard let postID = post.id else {
            print("😡 ERROR: post.id = \(post.id ?? "nil"). This should not have happened.")
            return false
        }
        
        do {
            let subcollectionRef = db.collection("posts").document(postID).collection("annotations")
            let batch = db.batch()
            do {
                let snapshot = try await subcollectionRef.getDocuments()
                for document in snapshot.documents {
                    batch.deleteDocument(document.reference)
                }
                try await batch.commit()
                print("🗑️ Subcollection succesfully deleted")
            } catch {
                print("😡 ERROR: removing subcollection \(error.localizedDescription)")
                return false
            }
            let _ = try await db.collection("posts").document(postID).delete()
            print("🗑️ Document succesfully deleted")
            return true
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
            return false
        }
    }
    
    func deleteAnnotation(post: Post) async -> Bool {
        let db = Firestore.firestore()
        guard let postID = post.id else {
            print("😡 ERROR: post.id = \(post.id ?? "nil"). This should not have happened.")
            return false
        }
        
        do {
            let subcollectionRef = db.collection("posts").document(postID).collection("annotations")
            let batch = db.batch()
            do {
                let snapshot = try await subcollectionRef.getDocuments()
                for document in snapshot.documents {
                    batch.deleteDocument(document.reference)
                }
                try await batch.commit()
                print("🗑️ Subcollection succesfully deleted")
            } catch {
                print("😡 ERROR: removing subcollection \(error.localizedDescription)")
                return false
            }
            print("🗑️ Document succesfully deleted")
            return true
        } catch {
            print("😡 ERROR: removing document \(error.localizedDescription)")
            return false
        }
    }
}
