//
//  HomeBarView.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI
import Firebase

struct HomeBarView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selection = 1
    
    var body: some View {
        TabView (selection: $selection) {
            ContactView()
                .tabItem {
                    Image(systemName: "phone")
                    Text("Contact")
                }
                .tag(0)
            
            HomescreenView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(1)
            
            MapViewModel()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Sign Out") {
                    do {
                        try Auth.auth().signOut()
                        print("🪵➡️ Log out successful!")
                        dismiss()
                    } catch {
                        print("😡 ERROR: Could not sign out!")
                    }
                }
            }
        }
    }
}

struct HomeBarView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeBarView()
                .environmentObject(HomescreenViewModel())
        }
    }
}
