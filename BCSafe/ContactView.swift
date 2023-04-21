//
//  ContactView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI

struct ContactView: View {
    var phoneNumber = "tel:207-650-8913"
    
    var body: some View {
        VStack {
            Link(destination: URL(string: phoneNumber)!) {
                Text("Call me")
            }
            
            AsyncImage(url: URL(string: "https://maps.googleapis.com/maps/api/streetview?size=400x400&location=47.5763831,-122.4211769&fov=80&heading=100&pitch=0&key=AIzaSyDqxLZ2hZ_f67vxaTbxf1k3YGDUgIH_l7Y")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
