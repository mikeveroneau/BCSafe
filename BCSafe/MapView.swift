//
//  MapView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI
import MapKit

struct MapViewModel: View {
    @EnvironmentObject var homescreenVM: HomescreenViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var annotationsLargeMap: [Annotation] = []
    @State private var showMessage = false
    @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0))
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $coordinateRegion, showsUserLocation: true, annotationItems: annotationsLargeMap) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
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
        .onAppear {
            coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0, longitude: locationManager.location?.coordinate.longitude ?? 0.0), span: MKCoordinateSpan(latitudeDelta: 0.0045, longitudeDelta: 0.0045))
            annotationsLargeMap = homescreenVM.postArray.map {$0.annotation}
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewModel()
            .environmentObject(HomescreenViewModel())
            .environmentObject(LocationManager())
    }
}
