//
//  ProfileView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//
import SwiftUI
import FirebaseFirestore
import SDWebImageSwiftUI

struct PetProfileView: View {
    @State private var navigateToSettingView = false
    @State private var profileImageUrl: String? // Store pet profile image URL
    
    @EnvironmentObject var petViewModel: CreatePetUserModel
    @EnvironmentObject var viewModel: AuthViewModel
    
    let pet: Pet
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
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
                    
                    // Profile Image and Name
                    VStack(spacing: 10) {
                        Text("Hi \(pet.name)♡")
                            .font(.custom("Inter", size: 35, relativeTo: .title))
                            .kerning(2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                        
                        // Display pet profile image
                        if let imageUrl = profileImageUrl, let url = URL(string: imageUrl) {
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .transition(.fade(duration: 0.1))
//                            AsyncImage(url: url) { image in
//                                image.resizable().scaledToFill()
//                            } placeholder: {
//                                ProgressView()
//                            }
//                            .frame(width: 140, height: 140)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                            .shadow(radius: 5)
//                            .id(imageUrl)
                        } else {
                            Image("PetProfile")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
//                            Circle()
//                                .fill(Color.gray.opacity(0.3))
//                                .frame(width: 140, height: 140)
//                                .overlay(Image(systemName: "camera.fill").font(.largeTitle))
                        }
                    }
                    .padding(.top, 30)
                    
                    // Info Box
                    VStack(alignment: .center, spacing: 5) {
                        if let dateOfBirth = pet.dateOfBirth {
                            Text("Date of Birth: \(dateOfBirth, formatter: dateFormatter)")
                        } else {
                            Text("Date of Birth: N/A")
                        }
                        Text("Zodiac: \(pet.zodiac)")
                        Text("Breed: \(pet.selectedBreed)")
                        Text("Favorite Snack: \(pet.favoriteSnack)")
                    }
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
                    .padding(.bottom, 30)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                if let userId = viewModel.userSession?.uid, let petId = pet.id {
                    print("Fetching profile image for pet ID: \(petId) and user ID: \(userId)")
                    Task {
                        await fetchProfileImage(petId: petId, userId: userId)
                    }
                } else {
                    print("Error: Pet ID or User ID is nil!")
                }
            }
        }
    }
    
    // Fetch profile image from Firestore
    func fetchProfileImage(petId: String, userId: String) async {
        let petRef = Firestore.firestore().collection("users").document(userId)
            .collection("pets").document(petId)
        
        do {
            let snapshot = try await petRef.getDocument()
            
            if let data = snapshot.data(), let imageUrl = data["profileImageUrl"] as? String, !imageUrl.isEmpty {
                print("Retrieved image URL: \(imageUrl) for pet \(petId)") // Debugging
                
                DispatchQueue.main.async {
                    self.profileImageUrl = imageUrl
                }
            } else {
                print("No image URL found for pet \(petId).")
            }
        } catch {
            print("Error fetching profile image: \(error.localizedDescription)")
        }
    }}

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
//            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.platinum, lineWidth: 1))
        }
        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.platinum, lineWidth: 1))
    }
}
