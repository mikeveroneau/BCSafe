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

struct Annotation: Identifiable {
    let id = UUID().uuidString
    var title: String
    var coordinate: CLLocationCoordinate2D

    var dictionary: [String: Any] {
            return ["title": title, "latitude": coordinate.latitude, "longitude": coordinate.longitude]
        }
}
