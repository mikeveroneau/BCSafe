//
//  ContactView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI

struct ContactView: View {
    @EnvironmentObject var addressVM: AddressViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    struct Contact: Hashable {
        var title: String
        var number: String
    }
    
    var phoneNumber = "tel:207-650-8913"
    
    let phoneNumbers: [Contact] = [Contact(title: "BC Police (Non Emergency)", number: "617-552-4440"), Contact(title: "Eagle Escort", number: "617-552-8888"), Contact(title: "BC Emergency Information Line", number: "888-267-2655"), Contact(title: "University Health Services", number: "617-552-3225"), Contact(title: "University Consulting Services", number: "617-552-3310"), Contact(title: "Sexual Assault Network", number: "617-552-2211"), Contact(title: "Student Services", number: "617-552-3300")]
    
    var body: some View {
        VStack (spacing: 0) {
            Link(destination: URL(string: phoneNumber)!) {
                ZStack {
                    Circle()
                        .frame(width: 250, height: 250)
                        .shadow(radius: 20, x: 30, y: -10)
                        .foregroundColor(Color("BCGold"))
                    
                    VStack {
                        Text("🚨")
                            .font(.system(size: 100))
                        Text("Press In Emergency")
                            .foregroundColor(Color("BCMaroon"))
                            .bold()
                    }
                }
            }
            .padding(.top)
            
            Text("Location: \(addressVM.address)")
                .padding(.horizontal)
                .padding(.top)
            
            NavigationStack {
                List {
                    ForEach(phoneNumbers, id: \.self) { number in
                        Link(destination: URL(string: "tel:\(number.number)")!) {
                            Text(number.title)
                        }
                    }
                }
                .navigationTitle("Press to Call")
                .listStyle(.plain)
            }
            .padding(.bottom)
        }
        .onAppear {
            Task {
                await addressVM.getData(latitude: Double(String(format: "%.1f", (locationManager.location!.coordinate.latitude * 10000000000000)).dropLast(2))!/10000000000000, longitude: Double(String(format: "%.1f", (locationManager.location!.coordinate.longitude * 10000000000000)).dropLast(2))!/10000000000000)
            }
        }
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
            .environmentObject(AddressViewModel())
            .environmentObject(LocationManager())
    }
}
