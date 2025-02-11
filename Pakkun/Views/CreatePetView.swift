//
//  CreatePetView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct CreatePetView: View {
    @EnvironmentObject var petViewModel: CreatePetUserModel
    @EnvironmentObject var viewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var navigateToProfilePhoto = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    @State private var showDiscardAlert = false
    
    let pet: Pet
    
    let animalBreeds: [String: [String]] = [
        "Dog": ["Beagle", "Chihuahua", "Pug", "French Bulldog", "Golden Retriever"],
        "Cat": ["Persian", "Siamese", "Maine Coon", "Sphynx", "Bengal"],
        "Bird": ["Parrot", "Canary", "Cockatiel", "Finch"],
        "Reptile": ["Iguana", "Gecko", "Snake", "Turtle"],
        "Fish": ["Goldfish", "Betta", "Guppy", "Angelfish"],
        "Small Pet": ["Rabbit", "Guinea Pig", "Hamster", "Ferret"]
    ]
    
    // validation function
    private func validatePet() -> Bool {
        if petViewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Name cannot be empty."
            return false
        }
        
        if petViewModel.zodiac.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Zodiac sign cannot be empty."
            return false
        }
        
        if petViewModel.favoriteSnack.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Favorite snack cannot be empty."
            return false
        }
        
        if petViewModel.dateOfBirth > Date() {
            errorMessage = "Date of birth must be in the past."
            return false
        }
        
        return true
    }
    
    private func updateBreed(for animal: String) {
        if let firstBreed = animalBreeds[animal]?.first {
            petViewModel.selectedBreed = firstBreed
        } else {
            petViewModel.selectedBreed = ""
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.blueBell)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Image("Pakkun")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 120)
                        .padding(.top, 16)
                    
                    Text("Create a Profile for your Furry Friend")
                        .kerning(2)
                        .font(.custom("Inter", size: 18, relativeTo: .title))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    
                    VStack(spacing: 15) {
                        TextField("Name", text: $petViewModel.name)
                            .padding()
                            .foregroundColor(Color.primary)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        DatePicker("Date of Birth", selection: $petViewModel.dateOfBirth, displayedComponents: [.date])
                            .padding()
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                        
                        TextField("Zodiac", text: $petViewModel.zodiac)
                            .padding()
                            .foregroundColor(Color.primary)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                        
                        TextField("Favorite Snack", text: $petViewModel.favoriteSnack)
                            .padding()
                            .foregroundColor(Color.primary)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                        
                        HStack(spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Type of Animal")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Picker("Type of Animal", selection: $petViewModel.selectedAnimal) {
                                    ForEach(animalBreeds.keys.sorted() as [String], id: \.self) { animal in
                                        Text(animal).tag(animal)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .onChange(of: petViewModel.selectedAnimal) { oldValue, newValue in
                                    updateBreed(for: newValue) // Moved logic to a function
                                }
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                
                                Text("Breed")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Picker("Breed", selection: $petViewModel.selectedBreed) {
                                    ForEach(animalBreeds[petViewModel.selectedAnimal] ?? [] as [String], id: \.self) { breed in
                                        Text(breed).tag(breed)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                        
                        HStack(spacing: 20) {
                            Button {
                                showDiscardAlert = true
                            } label: {
                                Text("Back")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .kerning(1)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                            .alert("Discard Pet Information?", isPresented: $showDiscardAlert) {
                                Button("Cancel", role: .cancel) {}
                                Button("Back me back to User Profile", role: .destructive) {
                                    petViewModel.resetPetData()
                                    dismiss()
                                }
                            } message: {
                                Text("If you go back now, any entered pet information will not be saved.")
                            }

                            Button {
                                if validatePet() {
                                    navigateToProfilePhoto = true
                                } else {
                                    showErrorAlert = true
                                }
                                Task {
                                    do {
                                        try await petViewModel.savePet(forUserId: viewModel.userSession?.uid ?? "")
                                    } catch {
                                        print("Error saving pet: \(error.localizedDescription)")
                                    }
                                }
                            } label: {
                                Text("Next")
                                    .font(.headline)
                                    .kerning(1)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                            }
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                    }
                    .padding()
                }
                .alert("Hi there!", isPresented: $showErrorAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(errorMessage)
                }
                .navigationDestination(isPresented: $navigateToProfilePhoto) {
                    ProfilePhotoView(pet: pet)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationBarBackButtonHidden(true)
        }
    }
}

