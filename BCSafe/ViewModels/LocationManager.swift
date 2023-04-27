//
//  LocationManager.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import Foundation
import MapKit

@MainActor
class LocationManager: NSObject, ObservableObject {
    var location: CLLocation?
    var region = MKCoordinateRegion()
    let latitudeDelta = 0.01
    let longitudeDelta = 0.01
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        self.location = location
        self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta))
    }
}
