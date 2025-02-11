//
//  UserLoginPageView.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
//

import SwiftUI

struct UserRegisterPageView: View {
    @State private var email: String = ""
    @State private var fullname: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToUserProfileView = false
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    
    let pet: Pet
    
    var body: some View {
        ZStack {
            Color(.blueBell)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Image("Pakkun")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.top, 16)
                Spacer()
                
                // Form fields
                VStack(spacing: 24) {
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@example.com")
                    .autocapitalization(.none)
                    
                    InputView(text: $fullname,
                              title: "Full Name",
                              placeholder: "Enter your name")
                    
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                    
                    ZStack(alignment: .trailing) {
                        InputView(text: $confirmPassword,
                                  title: "Confirm Password",
                                  placeholder: "Confirm your password",
                                  isSecureField: true)
                        
                        if !password.isEmpty && !confirmPassword.isEmpty {
                            if password == confirmPassword {
                                Image(systemName: "checkmark.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(.green)
                                    .fontWeight(.bold)
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                Spacer()
                // Sign up button
                Button {
                    Task {
                        try await viewModel.createUser(withEmail: email,
                                                       password: password,
                                                       fullname: fullname)
                    }
                    navigateToUserProfileView = true
                } label: {
                    HStack {
                        Text("SIGN UP")
                            .fontWeight(.semibold)
                            .kerning(3)
                            .font(.custom("Inter", size: 20))
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.platinum))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.bottom, 16) // Adjust padding for bottom space
                
                NavigationLink("", destination: UserProfileView(pet: pet))
                    .isDetailLink(false)
                    .opacity(0) // Hide the link
                    .disabled(!navigateToUserProfileView)
                
                // Sign in label
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                        Text("Sign in")
                            .fontWeight(.semibold)
                    }
                    .font(.system(size: 14))
//                    .background(Color(.clear))
                }
                .padding(.bottom, 32)
                .background(Color(.clear))
            }
        }
        .navigationDestination(isPresented: $navigateToUserProfileView) {
            UserProfileView(pet: pet)
        }
    }
}
// MARK: AuthenticationFormProtocol
extension UserRegisterPageView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains( "@" )
        && !password.isEmpty
        && password.count >= 6
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

