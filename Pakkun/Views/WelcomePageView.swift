//
//  WelcomePageView.swift
//  Pakkun
//
//  Created by New Student on 1/24/25.
//

import SwiftUI

struct WelcomePageView: View {
    @State private var navigateToPetProfileView = false
    @EnvironmentObject var petViewModel: CreatePetUserModel
    
    let pet: Pet
    
    var body: some View {
        ZStack {
            Color(.blueBell)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let pet = petViewModel.currentPet {
                    Text("Welcome \(pet.name)!")
                        .kerning(3)
                        .font(.custom("Inter", size: 30, relativeTo: .title))
                        .foregroundColor(.black)
                        .padding(.top, 20)
                        .padding(.bottom, 50)

                    if let loadedImage = petViewModel.loadImageFromDocuments(petId: petViewModel.petId) {
//                        print("Successfully loaded image for petId: \(petViewModel.petId)")
                        Image(uiImage: loadedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .padding(.bottom, 20)
                    } else {
                        Image("PetProfile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            .padding(.bottom, 20)
                    }
//                    Image("Pug") // replace image, add one in assets
//                        .resizable()
//                    //                    .scaledToFit()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 150, height: 150)
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
//                        .padding(.bottom, 20)
                    
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
                } else {
                    Text( "No pet found!")
                        .font(.title2)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $navigateToPetProfileView) {
            if let pet = petViewModel.currentPet {
                PetProfileView(pet: pet)
            }
        }.onAppear {
            if let savedPath = UserDefaults.standard.string(forKey: petViewModel.petId) {
                petViewModel.imagePath = savedPath // Load from persistent storage
            }
        }
    }
}
