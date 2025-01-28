//
//  WelcomePageView.swift
//  Pakkun
//
//  Created by New Student on 1/24/25.
//

import SwiftUI

struct WelcomePageView: View {
    var body: some View {
        ZStack {
            // Background color
            Color(.paleHazel)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Welcome Pet's Name!")
                    .kerning(3)
                    .font(.custom("Inter", size: 30, relativeTo: .title))
                    .foregroundColor(.black)
                    .padding(.top, 20)
//                Spacer()
                
                Image("") // replace image, add one in assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                Button(action: {
                   // navigate to main profile
                }) {
                    Text("Take me to my pet's profile ")
                        .kerning(1)
                        .font(.custom("Inter", size: 15, relativeTo: .headline))
//                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.95, green: 0.92, blue: 0.85)))
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
            }
            .padding()
        }
//        .navigationDestination(isPresented: $navigateToHealthInfo) {
//            HealthInfoView(name: viewModel.name)

    }
}

struct WelcomePageView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomePageView()
    }
}
