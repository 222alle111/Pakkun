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

    @State private var navigateToHealthInfo = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    
    @State var changeProfileImage = false
    @State private var openCameraRoll = false
    @State private var imageSelected: UIImage? = nil

    
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
                    Text("Create a Profile for your Furry Friend")
                        .kerning(2)
                        .font(.custom("Inter", size: 18, relativeTo: .title))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.top, 20)
                    // create button for image: image picker
                    ZStack {
                        Button(action: {
                            openCameraRoll = true
                        }, label: {
                            if changeProfileImage, let validImage = imageSelected {
                                Image(uiImage: validImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            } else {
                                Image("PetProfile")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                            }
                        })
                        
                        Image(systemName: "plus")
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .background(Color.white.opacity(0.7))
                            .clipShape(Circle())
                            .offset(x: 40, y: 40)
                    }

                    
                    VStack(spacing: 15) {
                        TextField("Name", text: $petViewModel.name)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())

                        DatePicker("Date of Birth", selection: $petViewModel.dateOfBirth, displayedComponents: [.date])
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))

                        TextField("Zodiac", text: $petViewModel.zodiac)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))

                        TextField("Favorite Snack", text: $petViewModel.favoriteSnack)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))

                        HStack(spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Type of Animal")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                Picker("Type of Animal", selection: $petViewModel.selectedAnimal) {
                                    ForEach(animalBreeds.keys.sorted(), id: \.self) { animal in
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
                                    ForEach(animalBreeds[petViewModel.selectedAnimal] ?? [], id: \.self) { breed in
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
//                                petViewModel.reset()
                                dismiss()
                            } label: {
                                Text("Back")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                            }

                            Button {
                                if validatePet() {
                                    navigateToHealthInfo = true
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
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                            }
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
                .navigationDestination(isPresented: $navigateToHealthInfo) {
                    if let userId = viewModel.userSession?.uid {
                        HealthInfoView(petId: petViewModel.petId, userId: userId, pet: pet) // Pass petId and userId
                            .environmentObject(petViewModel)
                            .environmentObject(viewModel)
                        } else {
                            Text("Error: No user session found")
                                .foregroundColor(.red)
                        }
                        }
                    }
                .scrollContentBackground(.hidden)
                .navigationBarBackButtonHidden(true)
        }.sheet(isPresented: $openCameraRoll) {
            ImagePicker(selectedImage: $imageSelected,
                        sourceType: .photoLibrary)
            .onDisappear {
                if let validImage = imageSelected {
                    if let savedPath = petViewModel.saveImageToDocuments(image: validImage, for: petViewModel.petId) {
                        DispatchQueue.main.async {
                            petViewModel.imagePath = savedPath
                            changeProfileImage = true
                        }
                    }
                } else {
                    changeProfileImage = false
                }
            }
            .ignoresSafeArea()
        }
        }
    }
