//
//  HomescreenViewModel.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import Foundation

class HomescreenViewModel: ObservableObject {
    @Published var postArray: [Post] = []
    
    func savePost(post: Post) {
        if post.id == nil {
            var newPost = post
            newPost.id = UUID().uuidString
            postArray.append(newPost)
        } else {
            if let index = postArray.firstIndex(where: {$0.id == post.id}) {
                postArray[index] = post
            }
        }
    }
}
