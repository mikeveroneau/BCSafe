//
//  Post.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

struct Post: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title = ""
    var message = ""
    var eventLocation = ""
    var showUserLocation = false
    var postedOn = Date()
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var latitude = 0.0
    var longitude = 0.0
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var annotation: Annotation {
        Annotation(title: title, latitude: latitude, longitude: longitude)
    }
    
    
    var dictionary: [String: Any] {
        return ["title": title, "message": message, "eventLocation": eventLocation, "showUserLocation": showUserLocation, "postedOn": Timestamp(date: Date()), "reviewer": reviewer, "latitude": latitude, "longitude": longitude]
    }
}
