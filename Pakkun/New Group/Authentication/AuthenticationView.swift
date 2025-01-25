//
//  AuthenticationView.swift
//  Pakkun
//
//  Created by New Student on 1/22/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
    
    func signInGoogle() async throws {
        guard let topVC = Utilities.shared.topViewController() else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        

    }
}


struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            // Header at the top
            HeaderView()
                .padding(.bottom, 25)
            
            // Main content
            VStack(spacing: 20) {
                Text("Login / Sign Up")
                    .kerning(3)
                    .font(.custom("Inter", size: 20, relativeTo: .headline))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                NavigationLink {
                    SignInEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign My Pet In")
                        .kerning(3)
                        .font(.custom("Inter", size: 20, relativeTo: .headline))
                        .foregroundColor(.black)
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .background(Color.platinum)

                        .cornerRadius(15)
                }
                
                NavigationLink(destination: CreatePetView()) {
                    Text("Create a New Pet")
                        .kerning(3)
                        .font(.custom("Inter", size: 20, relativeTo: .headline))
                        .foregroundColor(.black)
                        .frame(height: 35)
                        .frame(maxWidth: .infinity)
                        .background(Color.platinum)
                        .cornerRadius(15)
                }
                
                Button("Forgot Password?") {
                    // Add forgot password action here??
                }
                .kerning(1)
                .font(.custom("Inter", size: 12, relativeTo: .headline))
                .foregroundColor(.black)
            }
            .padding(.bottom, 15) // it adds padding at the bottom of the content
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print("Error signing in: \(error.localizedDescription)")
                    }
                }
            }
            .padding(.top, 20) // Add extra space above the Google Sign-In button
            
            Spacer()
        }
        .padding()
        .background(Color.paleHazel)
    }
}
        
struct AuthenticationView_Previews: PreviewProvider {
            static var previews: some View {
                NavigationStack {
                    AuthenticationView(showSignInView: .constant(false))
                }
            }
        }

