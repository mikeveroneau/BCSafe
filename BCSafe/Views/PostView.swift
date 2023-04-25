//
//  PostView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import MapKit

struct PostView: View {
    @EnvironmentObject var homescreenVM: HomescreenViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    @FirestoreQuery(collectionPath: "posts") var annotations: [Annotation]
    
    @Environment(\.dismiss) var dismiss
    
    @State var post: Post
    @State var postedByThisUser = false
    @State private var annotationsSmallMap: [Annotation] = []
    @State private var imageFront = "180"
    @State private var imageBack = "0"
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                TextField("Title", text: $post.title)
                    .font(.system(size: 45))
                    .bold()
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5))
                    }
                    .disabled(!postedByThisUser)
                
                Text("Date: \(post.postedOn.formatted())")
                
                TextField("Location", text: $post.eventLocation)
                    .padding(.horizontal, 6)
                    .font(.title)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5))
                    }
                    .disabled(!postedByThisUser)
                
                TextField("Message", text: $post.message, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5))
                    }
                    .disabled(!postedByThisUser)
                
                Toggle("Report Location?", isOn: $post.showUserLocation)
                    .disabled(!postedByThisUser)
                
                if post.showUserLocation {
                    if post.id == nil {
                        Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                            .cornerRadius(10)
                    } else {
                        HStack {
                            Map(coordinateRegion: $locationManager.region, showsUserLocation: false, annotationItems: annotationsSmallMap) { annotation in
                                MapAnnotation(coordinate: annotation.coordinate) {
                                    Image(systemName: "mappin")
                                        .font(.system(size: 40))
                                        .foregroundColor(.red)
                                }
                            }
                            .cornerRadius(10)
                            
                            VStack {
                                AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=\(post.latitude),\(post.longitude)&fov=80&heading=\(imageFront)&pitch=0&key=AIzaSyDClUil_VpFPEeWKynObTH_yE6nfDPbPGw")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                }
                                
                                AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=\(post.latitude),\(post.longitude)&fov=80&heading=\(imageBack)&pitch=0&key=AIzaSyDClUil_VpFPEeWKynObTH_yE6nfDPbPGw")) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(postedByThisUser)
            .onAppear {
                if post.reviewer == Auth.auth().currentUser?.email {
                    postedByThisUser = true
                }
                annotationsSmallMap = [post.annotation] //TODO: fix this
                if post.id != nil {
                    $annotations.path = "posts/\(post.id ?? "")/annotations"
                }
            }
            .toolbar {
                if postedByThisUser {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            if post.id == nil {
                                post.latitude = locationManager.region.center.latitude
                                post.longitude = locationManager.region.center.longitude
                            }
                            Task {
                                let successPost = await homescreenVM.savePost(post: post, annotation: post.annotation, showUserLocation: post.showUserLocation)
                                if successPost && post.id != nil {
                                    if post.showUserLocation == false {
                                        Task {
                                            let successDeleteAnnotation = await homescreenVM.deleteAnnotation(post: post)
                                            if successDeleteAnnotation {
                                                dismiss()
                                            }
                                        }
                                    }
                                    dismiss()
                                } else {
                                    print("No subcollection of annotations to add")
                                }
                            }
                            dismiss()
                        }
                    }
                }
                
                if post.id != nil && postedByThisUser {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        
                        Button {
                            Task {
                                let success = await homescreenVM.deletePost(post: post)
                                if success {
                                    dismiss()
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                        }

                    }
                }
            }
        }
        .padding()
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PostView(post: Post())
                .environmentObject(HomescreenViewModel())
                .environmentObject(LocationManager())
        }
    }
}
