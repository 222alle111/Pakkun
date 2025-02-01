//
//  WelcomePageView.swift
//  Pakkun
//
//  Created by New Student on 1/24/25.
//

import SwiftUI

struct WelcomePageView: View {
    @State private var navigateToPetProfileView = false
    
    var body: some View {
        ZStack {
            Color(.blueBell)
                .edgesIgnoringSafeArea(.all)
            
            VStack() {
                Text("Welcome Pet's Name!")
                    .kerning(3)
                    .font(.custom("Inter", size: 30, relativeTo: .title))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                    .padding(.bottom, 50)
            // Maybe change the space between text and image to more in the middle. Image should be in the middle
//                Spacer()
                
                Image("Pug") // replace image, add one in assets
                    .resizable()
//                    .scaledToFit()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                    .padding(.bottom, 20)
                
//                Spacer()
                
                Button(action: {
                    // navigate to main profile
                    navigateToPetProfileView = true
                }) {
                    Text("Take me to my pet's profile ")
                        .kerning(1)
                        .font(.custom("Inter", size: 15, relativeTo: .headline))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .navigationDestination(isPresented: $navigateToPetProfileView) {
            PetProfileView()
            
        }
    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
