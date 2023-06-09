//
//  BCSafeApp.swift
//  BCSafe
//
//  Created by mike on 4/19/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct BCSafeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var homescreenVM = HomescreenViewModel()
    @StateObject var locationManager = LocationManager()
    @StateObject var loginVM = LoginViewModel()
    @StateObject var staticAEDVM = StaticAnnotationsViewModel()
    @StateObject var addressVM = AddressViewModel()
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(homescreenVM)
                .environmentObject(locationManager)
                .environmentObject(loginVM)
                .environmentObject(staticAEDVM)
                .environmentObject(addressVM)
        }
    }
}
