//
//  HomescreenView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct HomescreenView: View {
    @FirestoreQuery(collectionPath: "posts") var posts: [Post]
    //@FirestoreQuery(collectionPath: "posts") var annotations: [Annotation]
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var homescreenVM: HomescreenViewModel
    @State private var postSheetIsPresented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if posts.isEmpty {
                    Text("Nothing To Show")
                        .padding(.top, 300)
                }
                
                List {
                    ForEach(posts) { post in
                        NavigationLink {
                            PostView(post: post)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(height: 100)
                                    .foregroundColor(.black.opacity(0.7))
                                    .cornerRadius(9)
                                
                                Text(post.title)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Alerts")
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵➡️ Log out successful!")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out!")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        postSheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $postSheetIsPresented) {
                NavigationStack {
                    PostView(post: Post())
                }
            }
        }
    }
}

struct HomescreenView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomescreenView()
                .environmentObject(HomescreenViewModel())
        }
    }
}
