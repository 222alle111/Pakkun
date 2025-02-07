//
//  ProfilePhotoView.swift
//  Pakkun
//
//  Created by New Student on 2/6/25.
//

import Foundation
import SwiftUI
import UIKit

struct ProfilePhotoView: View {
    @State private var navigateToHealthInfo = false
    
    @EnvironmentObject var petViewModel: CreatePetUserModel
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showImagePicker: Bool = false
    @State private var slectedImage: UIImage?
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
                    if let image = slectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 200, height: 200)
                            .overlay(Image(systemName: "camera.fill").font(.largeTitle))
                    }
                }
                .padding()
                .onTapGesture {
                    showActionSheet = true
                }
//                Spacer()
                
                // Bottom Buttons Row
                    Button(action: {
                        slectedImage = nil
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Delete")
                        }
                        .foregroundColor(.red)
                        .padding(.top, 5)
                    }
                Spacer()
                
                Button(action: {
                    //to health info
                    navigateToHealthInfo = true
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .font(.custom("Inter", size: 20, relativeTo: .headline))
                        .foregroundColor(.black)
                        .frame(maxWidth: 100, minHeight: 44)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                }
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
                        sourceType = .camera
                        showImagePicker = true
                    },
                    .destructive(Text("Delete Photo")) {
                        slectedImage = nil
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $slectedImage, sourceType: sourceType)
            }
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
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
    }
}
