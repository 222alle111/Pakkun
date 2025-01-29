//
//  PakkunApp.swift
//  Pakkun
//
//  Created by New Student on 1/21/25.
//

import SwiftUI
import Firebase
//import FirebaseCore
import GoogleSignIn

@main
struct PakkunApp: App {
    @StateObject var viewModel = AuthViewModel() // Initialized it in thie one place 
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            NavigationStack {
            ContentView()
//            HomePageView()
                .environmentObject(viewModel)
//                RootView()
//            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Configure Google Sign-In with the client ID
        if let clientID = FirebaseApp.app()?.options.clientID {
            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
        } else {
            print("Error: Failed to get clientID from Firebase configuration.")
        }
        
        return true
    }
    
//    // Handle URL callback for Google Sign-In
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
}
