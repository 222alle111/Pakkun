//
//  WelcomePageView.swift
//  Pakkun
//
//  Created by New Student on 1/24/25.
//
import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct WelcomePageView: View {
    @State private var navigateToPetProfileView = false
    @State private var profileImageUrl: String?
    
    @EnvironmentObject var petViewModel: CreatePetUserModel
    @EnvironmentObject var viewModel: AuthViewModel
    
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
                    
                    // Display the pet's profile image
                    if let imageUrl = profileImageUrl, let url = URL(string: imageUrl) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .transition(.fade(duration: 0.1))
//                        AsyncImage(url: url) { image in
//                            image.resizable().scaledToFill()
//                        } placeholder: {
//                            ProgressView()
//                        }
//                        .frame(width: 200, height: 200)
//                        .clipShape(Circle())
//                        .id(imageUrl)
                    } else {
                        Image("PetProfile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))

                    }
                    
                    Button(action: {
                        navigateToPetProfileView = true
                    }) {
                        Text("Take me to my pet's profile ")
                            .kerning(1)
                            .font(.custom("Inter", size: 15, relativeTo: .headline))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                    .padding(.horizontal, 30)
                    .padding(.top, 20)
                } else {
                    Text("No pet found!")
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
        }
        .onAppear {
            if let petId = petViewModel.currentPet?.id, let userId = viewModel.userSession?.uid {
                print("Fetching profile image for pet ID: \(petId) and user ID: \(userId)")
                Task {
                    await fetchProfileImage(petId: petId, userId: userId)
                }
            } else {
                print("No pet ID or user ID available!")
            }
        }
    }
    
    // Updated function to accept both petId and userId
    func fetchProfileImage(petId: String, userId: String) async {
        let petRef = Firestore.firestore().collection("users").document(userId)
            .collection("pets").document(petId)
        
        do {
            let snapshot = try await petRef.getDocument()
            
            if let data = snapshot.data(), let imageUrl = data["profileImageUrl"] as? String, !imageUrl.isEmpty {
                print("Retrieved image URL: \(imageUrl) for pet \(petId)")
                // Update the profile image URL for the specific pet
                DispatchQueue.main.async {
                    self.profileImageUrl = imageUrl
                }
            } else {
                print("No image URL found for this pet.")
            }
        } catch {
            print("Error fetching profile image: \(error.localizedDescription)")
        }
    }
}
