//
//  ProfileView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//
import SwiftUI

struct PetProfileView: View {
    @State private var navigateToSettingView = false
    @EnvironmentObject var petViewModel: CreatePetUserModel
    
    let pet: Pet
    
    // DateFormatter for formatting the pet's date of birth
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // medium
        formatter.timeStyle = .none
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blueBell
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Top Bar with Side Button
                    HStack {
                        Spacer()
                        Button(action: {
                            navigateToSettingView = true
                            print("Side Menu Tapped")
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.title)
                                .padding()
                                .foregroundColor(.black)
                        }
                        .navigationDestination(isPresented: $navigateToSettingView) {
                            UserProfileView(pet: pet)
                        }
                    }
                    .padding(.horizontal)
                    
                    //Profile Image and Name
                    VStack(spacing: 10) {
                        
                        Text("Hi \(pet.name) ♡") // \(name)
                            .font(.custom("Inter", size: 35, relativeTo: .title))
                            .kerning(2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                        
                        if let loadedImage = petViewModel.loadImageFromDocuments(petId: petViewModel.petId) {
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
//                        Image("Pug") // Replace with your actual image
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 140, height: 140)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                            .shadow(radius: 5)
                    }
//                    .padding(.top, -15) // Moves it lower
                    .padding(.top, 30)
                    
                    // Info Box
                    VStack(alignment: .center, spacing: 5) {
                        if let dateOfBirth = pet.dateOfBirth {
                            Text("Date of Birth: \(dateOfBirth, formatter: dateFormatter)")
                        } else {
                            Text("Date of Birth: N/A") // If dateOfBirth is nil
                        }
                        Text("Zodiac: \(pet.zodiac)")
                        Text("Breed: \(pet.selectedBreed)")
                        Text("Favorite Snack: \(pet.favoriteSnack)")
                    }
//                    .font(.subheadline)
                    .kerning(1)
                    .font(.custom("Inter", size: 16, relativeTo: .subheadline))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Centered Button Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        FeatureButton(icon: "pawprint", label: "Track Activity")
                        FeatureButton(icon: "stethoscope", label: "Medical History")
                        FeatureButton(icon: "carrot", label: "Food Logs")
                        FeatureButton(icon: "person.3", label: "Play with Friends")
                    }
                    .padding(.bottom, 30) // Moves it lower
                }
            }
            .scrollContentBackground(.hidden)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct FeatureButton: View {
    
    var icon: String
    var label: String
    
    var body: some View {
        Button(action: {
            // takes you to user profile view
            print("\(label) tapped")
        }) {
            VStack {
                Image(systemName: icon)
                    .font(.title)
                Text(label)
                    .font(.subheadline)
            }
            .frame(width: 140, height: 100)
            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.platinum, lineWidth: 1))
        }
    }
}
