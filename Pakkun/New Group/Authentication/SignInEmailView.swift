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
        //Initialize it
        @StateObject private var viewModel = SignInEmailViewModel()
        @Binding var showSignInView: Bool
        
        var body: some View {
            VStack {
                TextField("Email....", text: $viewModel.email)
                    .padding()
                    .background(Color.platinum)
                    .cornerRadius(30)
                
                SecureField("Password....", text: $viewModel.password)
                    .padding()
                    .background(Color.platinum)
                    .cornerRadius(30)
                
                Button {
                    Task {
                        do {
                            try await viewModel.signUp()
                            showSignInView = false // if this is successfully, it will dismiss view and return out of this func.
                            return
                        } catch {
                            print(error)
                        }
                        
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        } catch {
                            print(error)
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
        }
    }
    
    struct SignInEmailView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationStack {
                SignInEmailView(showSignInView: .constant(false))
            }
        }
    }

