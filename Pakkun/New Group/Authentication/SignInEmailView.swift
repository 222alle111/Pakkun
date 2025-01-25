//
//  SignInEmailView.swift
//  Pakkun
//
//  Created by New Student on 1/22/25.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.createUser(email: email, password: password)
        }
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        }
    }

struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool
    @State private var navigateToProfile = false // Add state for navigation

    var body: some View {
        VStack {
            TextField("Email....", text: $viewModel.email)
                .padding()
                .background(Color.platinum)
                .cornerRadius(30)
                .autocapitalization(.none)
                .autocorrectionDisabled()

            SecureField("Password....", text: $viewModel.password)
                .padding()
                .background(Color.platinum)
                .cornerRadius(30)

            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        navigateToProfile = true // Trigger navigation if sign-up succeeds
                    } catch {
                        print("Sign-up error: \(error)")
                    }

                    do {
                        try await viewModel.signIn()
                        navigateToProfile = true // Trigger navigation if sign-in succeeds
                    } catch {
                        print("Sign-in error: \(error)")
                    }
                }
            } label: {
                Text("Sign My Pet In")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
                    .background(Color.platinum)
                    .cornerRadius(15)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Sign In With Email")
        .background(Color.paleHazel)
        .navigationDestination(isPresented: $navigateToProfile) {
            ProfileView() // Navigate to ProfileView when `navigateToProfile` is true
        }
    }
}
    
struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}

