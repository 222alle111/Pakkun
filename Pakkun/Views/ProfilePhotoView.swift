//
//  ProfilePhotoView.swift
//  Pakkun
//
//  Created by New Student on 2/6/25.
//

import Foundation
import SwiftUI
import UIKit
import FirebaseStorage
import FirebaseFirestore

struct ProfilePhotoView: View {
    @State private var navigateToHealthInfo = false
    
    @EnvironmentObject var petViewModel: CreatePetUserModel
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var showActionSheet: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary

    let pet: Pet
    
    var body: some View {
        ZStack {
            Color(.blueBell)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Spacer()
                
                // Title
                Text("Profile Photo")
                    .kerning(3)
                    .font(.custom("Inter", size: 30, relativeTo: .title))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                
                Spacer()
                
                // Profile Image Display
                ZStack {
                    if let image = selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        Image("PetProfile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    }
                }
                .padding()
                .onTapGesture {
                    showActionSheet = true
                }
                
                // Delete Button
                Button(action: {
                    selectedImage = nil
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .foregroundColor(.red)
                    .padding(.top, 5)
                }
                .buttonStyle(PlainButtonStyle())
                
                Spacer()
                
                // Continue Button
                Button(action: {
                    Task {
                        if let selectedImage = selectedImage, let userId = viewModel.userSession?.uid {
                            await petViewModel.uploadPetImage(selectedImage, for: userId, petId: petViewModel.petId)
                        }
                        navigateToHealthInfo = true
                    }
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .font(.custom("Inter", size: 20, relativeTo: .headline))
                        .foregroundColor(.black)
                        .frame(maxWidth: 100, minHeight: 44)
                }
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                .padding(.top, 15)
                
                Spacer()
            }
            .padding(.bottom, 40)
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(title: Text("Choose an option"), buttons: [
                    .default(Text("Choose from Library")) {
                        sourceType = .photoLibrary
                        showImagePicker = true
                    },
                    .default(Text("Take a Photo")) {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            sourceType = .camera
                            showImagePicker = true
                        } else {
                            print("Camera not available")
                        }
                    },.cancel()
                ])
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: sourceType)
            }
        }
        .navigationDestination(isPresented: $navigateToHealthInfo) {
            if let userId = viewModel.userSession?.uid {
                HealthInfoView(petId: petViewModel.petId, userId: userId, pet: pet)
                    .environmentObject(petViewModel)
                    .environmentObject(viewModel)
            } else {
                Text("Error: No user session found")
                    .foregroundColor(.red)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
    }
}

func updatePetImageUrl(for userId: String, petId: String, imageUrl: String) async {
    let db = Firestore.firestore()
    let petRef = db.collection("users").document(userId).collection("pets").document(petId)

    do {
        try await petRef.updateData(["profileImageUrl": imageUrl])
        print("Profile image URL successfully saved!")
    } catch {
        print("Error saving image URL: \(error.localizedDescription)")
    }
}
