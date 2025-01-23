//
//  AuthenticationView.swift
//  Pakkun
//
//  Created by New Student on 1/22/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct AuthenticationView: View {
    
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack {
            Spacer() // Push content to the center
            
            // Text above the button
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
                //.font(.headline)
                    .font(.custom("Inter", size: 20, relativeTo: .headline))
                    .foregroundColor(.black)
                    .frame(height: 35)
                    .frame(maxWidth: .infinity)
                    .background(Color.platinum)
                    .cornerRadius(15)
            }
            
            .padding(.top, 10) // Space between the label and button
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .light, style: .wide, state: .normal)) {
                
            }
            .padding(.top, 20) // Space between the button and Google button
            
            Spacer()
        }
        .padding()
        .background(Color.paleHazel)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack() {
                   Spacer()
                    
                    Text("Welcome To PAKKUN")
                        .kerning(7)
                        .font(.custom("Inter", size: 32, relativeTo: .largeTitle))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 300)
                    
                    Text("Track your pet's health, schedule vet visits, and more.")
                        .kerning(1)
                        .font(.custom("Inter", size: 18, relativeTo: .title3))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 40)
                    
                    Spacer()
                }
                .padding(.horizontal) // Add horizontal padding for better text readability
                        
                Spacer() // Push content to center vertically
            }
        }
    }
}
        
struct AuthenticationView_Previews: PreviewProvider {
                    static var previews: some View {
                        NavigationStack {
                            AuthenticationView(showSignInView: .constant(false))
                        }
                    }
                }
            
        

