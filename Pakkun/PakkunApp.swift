//
//  PakkunApp.swift
//  Pakkun
//
//  Created by New Student on 1/21/25.
//

import SwiftUI
import Firebase
import FirebaseCore

@main
struct PakkunApp: App {
    
   @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                RootView()
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()

    return true
  }
}
