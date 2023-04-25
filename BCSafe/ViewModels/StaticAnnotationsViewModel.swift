//
//  StaticAnnotationsViewModel.swift
//  BCSafe
//
//  Created by mike on 4/24/23.
//

import Foundation

class StaticAnnotationsViewModel: ObservableObject {
    var aedLocations = [Annotation(id: UUID().uuidString, title: "AED - Maloney Hall\n1st Floor: BCPD lobby\n2nd Floor: Kitchen Area (Near Elevator Lobby)\n3rd Floor: Kitchen Area (Near Elevator Lobby)", latitude: 42.336334, longitude: -71.1685607), Annotation(id: UUID().uuidString, title: "AED - Higgins Hall\n3rd Floor: Hallway Outside Room 347", latitude: 42.3350195, longitude: -71.168754), Annotation(id: UUID().uuidString, title: "AED - Conte Forum\n1st Floor: Skate Lobby (Near Ice Area Entrance)\n1st Floor: Sports Medicine\n2nd Floor: Powers Gym", latitude: 42.3350662, longitude: -71.1677143), Annotation(id: UUID().uuidString, title: "AED - Merket Chemistry Center\n1st Floor: Hallway Outside Main Office\n3rd Floor: Hallway (Central)", latitude: 42.3338713, longitude: -71.1673907), Annotation(id: UUID().uuidString, title: "AED - Yawkey Athletic Center\n1st Floor: Trainer Hallway\n2nd Floor: Hallway Outside Weight Room)", latitude: 42.336067, longitude: -71.1664624), Annotation(id: UUID().uuidString, title: "AED - Fish Field House\n1st Floor: Sports Medicine\n1st Floor: Strength and Conditioning", latitude: 42.3346258, longitude: -71.1646187), Annotation(id: UUID().uuidString, title: "AED - Margot Connell Recreation Center\n1st Floor: Pool Area Lifeguard Office\n1st Floor: Hallway Outside Trainer's Office)\n2nd Floor: Landing at Top of Stairs)\n3rd Floor: Landing at Top of Stairs)\n4th Floor: Landing at Top of Stairs)", latitude: 42.3373247, longitude: -71.1645943), Annotation(id: UUID().uuidString, title: "AED - University Health Services\n1st Floor: Health Services", latitude: 42.3390615, longitude: -71.1648091), Annotation(id: UUID().uuidString, title: "AED - Cadigan Alumni Center\n1st Floor: Main Lobby", latitude: 42.3413524, longitude: -71.1640559), Annotation(id: UUID().uuidString, title: "AED - Harrington Athletics Village at Brighton Fields\n1st Floor: Near Training Room\n1st Floor: On Concourse", latitude: 42.3443406, longitude: -71.160959), Annotation(id: UUID().uuidString, title: "AED - Quonset Hut\n1st Floor: Front Desk", latitude: 42.3443716, longitude: -71.1941907)]
    
    func getDirections(aed: Annotation) {
        //TODO: Give Person Directions If They Ask For Them
    }
}
