//
//  MapView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI
import MapKit

struct MapViewModel: View {
    struct Annotation: Identifiable {
        let id = UUID().uuidString
        var title: String
        var coordinate: CLLocationCoordinate2D
    }
    @State private var annotations: [Annotation] = []
    @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 42.33845459989143, longitude: -71.16541216111281), span: MKCoordinateSpan(latitudeDelta: 0.045, longitudeDelta: 0.045))
    @State private var showMessage = false
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $coordinateRegion, showsUserLocation: false, annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Button {
                        showMessage = true
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
                            
                            Text(annotations[0].title)
                                .bold()
                        }
                    }
                }
            }
        }
        .onAppear {
            annotations.append(Annotation(title: "Help", coordinate: CLLocationCoordinate2D(latitude: 42.33845459989143, longitude: -71.16541216111281)))
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapViewModel()
    }
}
