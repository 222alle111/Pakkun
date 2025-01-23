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
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Email not found"])
        }
        
       try await AuthenticationManager.shared.resetPassword(email: email)
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
        List {
            Button("Logout") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                        
                    } catch{
                        print("Error: \(error)")
                    }
                }
            }
            
            Button("Forgot password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset successful")
                    } catch {
                        print("Failed to reset password: \(error.localizedDescription)")
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
        .navigationTitle("Settings") //might have to create vstack
        .background(Color.paleHazel)
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingView(showSignInView: .constant(false))
        }
    }
}
