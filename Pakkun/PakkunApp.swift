//
//  PakkunApp.swift
//  Pakkun
//
//  Created by New Student on 1/21/25.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct PakkunApp: App {
    
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var viewModel = AuthViewModel() // Initialized it in thie one place
    @StateObject var petViewModel = CreatePetUserModel()

    let pet = Pet(
        id: nil,
        name: "Buddy",
        dateOfBirth: nil,
        zodiac: "Leo",
        favoriteSnack: "Bone",
        selectedAnimal: "Dog",
        selectedBreed: "Golden Retriever"
    )

    var body: some Scene {
        WindowGroup {
            NavigationView {
//                HomePageView(pet: pet) // Uses a default pet
                ContentView(pet: pet)
                    .environmentObject(viewModel)
                    .environmentObject(petViewModel)
            }
        }
    }
}
    



//  var body: some Scene {
//    WindowGroup {
//      NavigationView {
//        //ContentView()
//          HomePageView(pet: pet)
//              .environmentObject(viewModel)
//              .environmentObject(petViewModel)
//
//      }
//    }
//  }
//}

//import Firebase
////import FirebaseCore
//import GoogleSignIn
//
//@main
//struct PakkunApp: App {
//    @StateObject var viewModel = AuthViewModel() // Initialized it in thie one place
//    @StateObject var petViewModel = CreatePetUserModel()
//    
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    
//    var body: some Scene {
//        WindowGroup {
////            NavigationStack {
////            ContentView()
//            HomePageView()
//                .environmentObject(viewModel)
//                .environmentObject(petViewModel)
////                RootView()
////            }
//        }
//    }
//}
//
//class AppDelegate: NSObject, UIApplicationDelegate {
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // Initialize Firebase
//        FirebaseApp.configure()
//        
//        // Configure Google Sign-In with the client ID
//        if let clientID = FirebaseApp.app()?.options.clientID {
//            GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: clientID)
//        } else {
//            print("Error: Failed to get clientID from Firebase configuration.")
//        }
//        
//        return true
//    }
    
//    // Handle URL callback for Google Sign-In
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }

