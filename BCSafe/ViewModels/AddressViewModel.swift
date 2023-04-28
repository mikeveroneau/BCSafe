//
//  AddressViewModel.swift
//  BCSafe
//
//  Created by mike on 4/28/23.
//

import Foundation

@MainActor
class AddressViewModel: ObservableObject {
    @Published var address = ""
    
    struct Result: Codable {
        var features: [Features]
    }
    
    struct Features: Codable {
        var properties: Properties
    }
    
    struct Properties: Codable {
        var formatted: String
    }

    func getData(latitude: Double, longitude: Double) async {
        let urlString = "https://api.geoapify.com/v1/geocode/reverse?lat=\(latitude)8&lon=\(longitude)&apiKey=48a0da4aa0d748e18fde3ffbe98ab96b"
        print("🕸️ We are accessing the url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create the url from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let result = try? JSONDecoder().decode(Result.self, from: data) else {
                print("😡 ERROR: Could not decode returned JSON data")
                return
            }
            address = result.features.first?.properties.formatted ?? "No address found"
        } catch {
            print("😡 ERROR: Could not use url at \(urlString) to get data and response")
        }
    }
}
