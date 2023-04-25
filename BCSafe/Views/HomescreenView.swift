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
                    ForEach(posts.sorted(by: {$0.postedOn > $1.postedOn})) { post in
                        NavigationLink {
                            PostView(post: post, annotation: post.annotation)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(height: 100)
                                    .foregroundColor(Color("BCGold"))
                                    .cornerRadius(9)
                                
                                VStack {
                                    Text(post.title)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.system(size: 40))
                                        .bold()
                                    
                                    HStack {
                                        Text(post.message)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .lineLimit(1)
                                        
                                        Text(postAge(date: post.postedOn))
                                            .padding(.trailing)
                                    }
                                }
                                .foregroundColor(.black.opacity(0.7))
                                .padding(.leading)
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
                    PostView(post: Post(), annotation: Annotation())
                }
            }
        }
    }
    func postAge(date: Date) -> String {
        let dateSince = date.timeIntervalSince(Date.now)
        if abs(dateSince)/3600 >= 1.0 {
            return String(abs(Int(dateSince)/3600))+"h ago"
        } else {
            return String(abs(Int(dateSince)/60))+"m ago"
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
