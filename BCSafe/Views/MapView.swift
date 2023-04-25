//
//  MapView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//
import SwiftUI
import MapKit
import FirebaseFirestoreSwift

struct MapView: View {
    @FirestoreQuery(collectionPath: "posts") var posts: [Post]
    
    @EnvironmentObject var homescreenVM: HomescreenViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var staticAEDVM: StaticAnnotationsViewModel
    
    @State private var annotationsLargeMap: [Post] = []
    @State private var showMessage = false
    @State private var showAED = false
    @State private var showPosts = true
    @State private var aedButton = ""
    @State private var showAEDAlert = false
    @State private var aedAlertMessage = ""
    @State private var showPostAlert = false
    @State private var postAlertMessage = ""
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: posts.filter({$0.showUserLocation == true})+annotationsLargeMap) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    if annotation.eventLocation.isEmpty && showAED {
                        Button {
                            aedAlertMessage = annotation.title
                            showAEDAlert = true
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                        }
                    } else if showPosts {
                        Button {
                            postAlertMessage = "\(annotation.title): \(annotation.message)\nLocation: \(annotation.eventLocation)"
                            showPostAlert = true
                        } label: {
                            Image(systemName: "mappin")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            
            VStack {
                Rectangle()
                    .fill(Color.white.opacity(0.8))
                    .blur(radius: 5)
                    .ignoresSafeArea()
                    .frame(height: 8)
                
                Spacer()
            }
            
            ZStack {
                Rectangle()
                    .frame(width: 45, height: 100)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                Rectangle()
                    .frame(width: 45, height: 1)
                    .foregroundColor(.gray)
                
                VStack {
                    
                    Button {
                        showAED.toggle()
                        if showAED {
                            for aed in staticAEDVM.aedLocations {
                                annotationsLargeMap.append(aed)
                            }
                        } else {
                            annotationsLargeMap.removeAll(where: {staticAEDVM.aedLocations.contains($0)})
                        }
                    } label: {
                        if showAED {
                            Image(systemName: "heart.fill")
                        } else {
                            Image(systemName: "heart")
                        }
                    }
                    .padding(.bottom, 12)
                    
                    Button {
                        showPosts.toggle()
                    } label: {
                        if showPosts {
                            Image(systemName: "mappin")
                        } else {
                            Image(systemName: "mappin.slash")
                        }
                    }
                }
                .foregroundColor(.red)
                .font(.system(size: 30))
            }
            .padding(.leading, 300)
            .padding(.bottom, 600)
        }
        .alert(aedAlertMessage, isPresented: $showAEDAlert) {
            Button("OK", role: .cancel) {}
        }
        .alert(postAlertMessage, isPresented: $showPostAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(HomescreenViewModel())
            .environmentObject(LocationManager())
            .environmentObject(StaticAnnotationsViewModel())
    }
}
