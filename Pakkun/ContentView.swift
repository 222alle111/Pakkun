//
//  ContentView.swift
//  Pakkun
//
//  Created by New Student on 1/21/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewMoodel: AuthViewModel
    @EnvironmentObject var petViewModel: CreatePetUserModel
    
    let pet: Pet
    
    var body: some View {
       Group {
            if viewMoodel.userSession != nil {
                UserProfileView(pet: pet)
            } else {
                HomePageView(pet: pet)
            }
        }
    }
}
