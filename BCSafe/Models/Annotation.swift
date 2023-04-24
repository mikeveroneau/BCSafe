//
//  Annotation.swift
//  BCSafe
//
//  Created by mike on 4/21/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import CoreLocation

struct Annotation: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var title = ""
    var latitude = 0.0
    var longitude = 0.0
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var dictionary: [String: Any] {
            return ["title": title, "latitude": latitude, "longitude": longitude]
        }
}
