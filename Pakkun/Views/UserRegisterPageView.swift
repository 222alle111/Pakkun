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
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateToUserProfileView = false
    
    var body: some View {
        ZStack {
            Color(.blueBell)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer() // Push everything to the top
                
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
                
                Spacer() // Add space between form fields and the button
                
                // Sign up button
                Button {
                    //                    print("Sign user up..")
                    //                    print(viewModel)
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
                
                NavigationLink("", destination: UserProfileView())
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
                }
                .padding(.bottom, 32) // Additional padding to ensure spacing from screen bottom
            }
        }
        .navigationDestination(isPresented: $navigateToUserProfileView) {
            UserProfileView()
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

struct UserRegisterPageView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegisterPageView()
    }
}
