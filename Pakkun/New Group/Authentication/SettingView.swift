//
//  SettingView.swift
//  Pakkun
//
//  Created by New Student on 1/22/25.
//

import SwiftUI

@MainActor
final class SettingViewModel: ObservableObject {
    
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func updatePassword() async throws {
        let passsword = "Hello123"
        try await AuthenticationManager.shared.updatePassword(password: passsword)
    }
}

struct SettingView: View {
    
    @StateObject private var viewModel = SettingViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        ZStack {
            // Background color for the entire view
            Color.paleHazel
                .ignoresSafeArea() // Ensures the background extends to safe areas
            
            // Content of the settings screen
            List {
                Button("Logout") {
                    Task {
                        do {
                            try viewModel.signOut()
                            showSignInView = true
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                }
                
                Button("Update password") {
                    Task {
                        do {
                            try await viewModel.updatePassword()
                            print("Password updated successfully!")
                        } catch {
                            print("Failed to update password: \(error.localizedDescription)")
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden) // removes the default background  color of the List
            .background(Color.paleHazel) // Explicitly set the List background
        }
        .navigationTitle("Settings")
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingView(showSignInView: .constant(false))
        }
    }
}
