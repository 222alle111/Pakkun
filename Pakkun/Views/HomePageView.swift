//
//  HomeView.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
//

import SwiftUI

struct HomePageView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showUserProfile = false
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    let pet: Pet

    // Form validation
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count >= 6
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.blueBell)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Header at the top
                    HeaderView()
                        .padding(.bottom, 25)
                    
                    // Form fields
                    VStack(spacing: 24) {
                        InputView(text: $email,
                                  title: "Email Address",
                                  placeholder: "name@example.com")
                        .autocapitalization(.none)
                        
                        InputView(text: $password,
                                  title: "Password",
                                  placeholder: "Enter your password",
                                  isSecureField: true)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)
                    
                    // Sign in button
                    Button {
                        Task {
                            do {
                                try await viewModel.signIn(withEmail: email, password: password)
                                showUserProfile = true
//                                navigateToUserProfileView = true // Trigger navigation
                            } catch {
                                print("Login failed: \(error.localizedDescription)")
                            }
                        }
                    } label: {
                        HStack {
                            Text("SIGN IN")
                                .fontWeight(.semibold)
                                .kerning(3)
                                .font(.custom("Inter", size: 20))
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                    }
                    .background(Color(.platinum))
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    .cornerRadius(20)
                    .padding(.top, 24)

                    // Navigation link to user profile
                    NavigationLink("", destination: UserProfileView(pet: pet))
                        .isDetailLink(false)
                        .opacity(0) // Hide the link
                        .disabled(!showUserProfile)

                    // Link to the registration page
                    NavigationLink {
                        UserRegisterPageView(pet: pet)
                            .environmentObject(viewModel)
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Text("Create a New Account")
                                .fontWeight(.semibold)
                                .kerning(3)
                                .font(.custom("Inter", size: 20))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 35)
                    }
                    .background(Color(.platinum))
                    .cornerRadius(20)
                }
            }
            .fullScreenCover(isPresented: $showUserProfile) {
                UserProfileView(pet: pet)
            }
        }
    }
}
