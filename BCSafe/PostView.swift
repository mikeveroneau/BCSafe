//
//  PostView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI
import Firebase
import MapKit

struct PostView: View {
    @EnvironmentObject var homescreenVM: HomescreenViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    @Environment(\.dismiss) var dismiss
    
    @State var post: Post
    @State private var mapRegion = MKCoordinateRegion()
    //@State private var showUserLocation = false
    
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
                
                Text("Date: \(post.postedOn.formatted())")
                
                TextField("Location", text: $post.eventLocation)
                    .font(.title)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5))
                    }
                
                TextField("Message", text: $post.message, axis: .vertical)
                    .padding(.horizontal, 6)
                    .frame(maxHeight: .infinity, alignment: .topLeading)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5))
                    }
                
                Toggle("Report Location?", isOn: $post.showUserLocation)
                
                if post.showUserLocation {
                    Map(coordinateRegion: $locationManager.region, showsUserLocation: true)
                        .cornerRadius(10)
                }
            }
            .navigationBarBackButtonHidden()
            .onAppear {
                post.latitude = locationManager.region.center.latitude
                post.longitude = locationManager.region.center.longitude
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        homescreenVM.savePost(post: post)
                        dismiss()
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
