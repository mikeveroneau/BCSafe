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
    @FirestoreQuery(collectionPath: "posts") var annotations: [Annotation]
    
    @EnvironmentObject var homescreenVM: HomescreenViewModel
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var staticAEDVM: StaticAnnotationsViewModel
    
    @State private var annotationsLargeMap: [Annotation] = []
    @State private var showMessage = false
    @State private var showAED = true
    @State private var aedButton = ""
    @State private var showAEDAlert = false
    @State private var aedAlertMessage = ""
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: annotationsLargeMap) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    if annotation.title.contains("AED -") {
                        Button {
                            aedAlertMessage = annotation.title
                            showAEDAlert = true
                        } label: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.red)
                        }
                    } else {
                        Button {
                            showMessage.toggle()
                        } label: {
                            Image(systemName: "mappin")
                                .font(.system(size: 40))
                                .foregroundColor(.red)
                        }
                        if showMessage {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    .cornerRadius(3)
                                
                                Text(annotation.title)
                                    .bold()
                            }
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
                //TODO: Fix this
                
                Spacer()
            }
            
            ZStack {
                Rectangle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .cornerRadius(6)
                
                
                Button {
                    showAED.toggle()
                    if showAED {
                        for aed in staticAEDVM.aedLocations {
                            annotationsLargeMap.append(aed)
                        }
                    } else {
                        annotationsLargeMap.removeAll(where: { staticAEDVM.aedLocations.contains($0) })
                    }
                } label: {
                    if showAED {
                        Image(systemName: "heart.fill")
                    } else {
                        Image(systemName: "heart")
                    }
                }
                .foregroundColor(.red)
            }
            .padding(.leading, 300)
            .padding(.bottom, 600)
        }
        .alert(aedAlertMessage, isPresented: $showAEDAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            //coordinateRegion = locationManager.region
            for aed in staticAEDVM.aedLocations {
                annotationsLargeMap.append(aed)
            }
        }
        .onChange(of: posts) { _ in
            annotationsLargeMap.removeAll()
            for post in posts {
                $annotations.path = "posts/\(post.id ?? "")/annotations"
                for annotation in annotations {
                    annotationsLargeMap.append(annotation)
                }
            }
            //TODO: Make this work right
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
