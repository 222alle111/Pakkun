//
//  SignInEmailView.swift
//  Pakkun
//
//  Created by New Student on 1/22/25.
//

import SwiftUI

//
//@MainActor
//final class SignInEmailViewModel: ObservableObject {
//    @Published var email: String = ""
//    @Published var password = ""
//    @Published var errorMessage: String = ""
//    
//    func signUp() async throws {
//        guard validate() else {
//            return
//        }
//        try await AuthenticationManager.shared.createUser(email: email, password: password)
//    }
//    
//    func signIn() async throws {
//        guard validate() else {
//            return
//        }
//        try await AuthenticationManager.shared.signInUser(email: email, password: password)
//    }
//    
//    func validate() -> Bool {
//        errorMessage = "" // Reset error message
//        
//        // Basic validation
//        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
//              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
//            errorMessage = "Please fill in all fields."
//            return false
//        }
//        
//        guard email.contains("@") && email.contains(".") else {
//            errorMessage = "Invalid email. Please enter a valid email."
//            return false
//        }
//        
//        return true
//    }
//}
//
//struct SignInEmailView: View {
//    @StateObject private var viewModel = SignInEmailViewModel()
//    @Binding var showSignInView: Bool
//    @State private var navigateToDogProfileView = false // Add state for navigation
//    @State private var isSignUp = true // Add state for sign-up or sign-in logic
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                // Show error message if it exists
//                if !viewModel.errorMessage.isEmpty {
//                    Text(viewModel.errorMessage)
//                        .foregroundColor(.red)
//                        .padding(.bottom, 10)
//                }
//                
//                TextField("Email....", text: $viewModel.email)
//                    .padding()
//                    .background(Color.platinum)
//                    .cornerRadius(30)
//                    .autocapitalization(.none)
//                    .autocorrectionDisabled()
//                
//                SecureField("Password....", text: $viewModel.password)
//                    .padding()
//                    .background(Color.platinum)
//                    .cornerRadius(30)
//                
//                Button {
//                    Task {
//                        if viewModel.validate() { // Only proceed if validated
//                            do {
//                                if isSignUp {
//                                    try await viewModel.signUp()
//                                } else {
//                                    try await viewModel.signIn()
//                                }
//                                navigateToDogProfileView  = true // Trigger navigation if successful
//                            } catch {
//                                print("Authentication error: \(error)")
//                            }
//                        }
//                    }
//                } label: {
//                    Text("Sign My Pet In")
//                        .font(.headline)
//                        .foregroundColor(.black)
//                        .frame(height: 35)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.platinum)
//                        .cornerRadius(15)
//                }
//                
//                Spacer()
//            }
//            .padding()
//            .background(Color.paleHazel)
//            .navigationTitle("Sign In With Email")
//            .navigationDestination(isPresented: $navigateToDogProfileView ) {
//                DogProfileView() // Navigate to ProfileView when `navigateToProfile` is true
//            }
//        }
//    }
//}
//    
//struct SignInEmailView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            SignInEmailView(showSignInView: .constant(false))
//        }
//    }
//}

