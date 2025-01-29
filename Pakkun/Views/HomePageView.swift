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
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                            try await viewModel.signIn(withEmail: email,
                                                       password: password)
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
                    .cornerRadius(20)
                    .padding(.top, 24)
                    
                    NavigationLink {
                        UserRegisterPageView()
                            .environmentObject(viewModel) 
                            .navigationBarBackButtonHidden(true)
                    } label: {
                        HStack {
                            Text("Create a New Account")
                                .kerning(3)
                                .fontWeight(.semibold)
                                .font(.custom("Inter", size: 20, relativeTo: .headline))
                        }
                        .foregroundColor(.black)
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .background(Color(.platinum))
                        .cornerRadius(20)
                    }
                }
            }
        }
    }
}

//                NavigationLink(destination: UserRegisterPageView()
//                    .environmentObject(viewModel)
//                    .navigationBarBackButtonHidden(true)
//                    ) {
//                    Text("Create a New Account")
//                        .kerning(3)
//                        .fontWeight(.semibold)
//                        .font(.custom("Inter", size: 20, relativeTo: .headline))
//                        .foregroundColor(.black)
//                        .frame(height: 35)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.platinum)
//                        .cornerRadius(20)
//                    }
//                }



struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
