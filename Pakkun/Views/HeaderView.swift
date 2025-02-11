//
//  HeaderView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//

import SwiftUI

struct HeaderView: View {
    
    var body: some View {
        VStack(spacing: 20) { // Adjust spacing between texts
            
            Text("WELCOME TO PAKKUN")
                .kerning(7)
                .font(.custom("Inter", size: 32, relativeTo: .largeTitle))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 50)
            
            Text("Track your pet's health, schedule vet visits, and more.")
                .kerning(1)
                .font(.custom("Inter", size: 18, relativeTo: .title3))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 35)
        }
        .padding(.horizontal) // Add horizontal padding for better readability
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
