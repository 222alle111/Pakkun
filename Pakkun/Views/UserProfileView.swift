//
//  UserProfileView.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var petViewModel: CreatePetUserModel
    @Environment(\.dismiss) var dismiss

    @State private var navigateToCreatePetView = false
//    @State private var navigateToPetProfileView = false
    @State private var navigateToHomePageView = false
    @State private var showDeleteAlert = false  // State to control the alert

    let pet: Pet

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.blueBell)
                    .edgesIgnoringSafeArea(.all)

                if viewModel.userSession == nil {
//                    HomePageView(pet: pet)
                } else if let user = viewModel.currentUser {
                    List {
                        // Profile Header
                        Section {
                            HStack {
                                Text(user.initials)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.platinum)
                                    .frame(width: 72, height: 72)
                                    .background(Color(.blueBell))
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(user.fullname)
                                        .font(.custom("Inter", size: 15, relativeTo: .subheadline))
                                        .kerning(1)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)

                                    Text(user.email)
                                        .font(.custom("Inter", size: 12, relativeTo: .footnote))
                                        .kerning(1)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.5))

                        // Pets Section
                        Section("Your Pets") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    if let pets = viewModel.currentUser?.pets {
                                        ForEach(pets, id: \.id) { pet in
                                            NavigationLink(destination: PetProfileView(pet: pet)) {
                                                PetCardView(pet: pet)
                                                    .frame(width: 130, height: 100)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    Button(action: {
                                        navigateToCreatePetView = true
                                    }) {
                                        AddPetCardView()
                                    }
                                }
                            }
                            .listRowBackground(Color.white.opacity(0.5))
                        }

                        // Settings Section
                        Section("Settings") {
                            SettingRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .paleHazel) {
                                viewModel.SignOut()
//                                navigateToHomePageView = true
                            }

                            SettingRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red) {
                                showDeleteAlert = true  // Show alert before deleting
                            }
                        }
                        .listRowBackground(Color.white.opacity(0.5))
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .navigationDestination(isPresented: $navigateToCreatePetView) {
                        CreatePetView(pet: pet)
                    }
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        Task {
                            await viewModel.fetchUser()
                        }
                    }
                }
            }
            .onAppear {
                if viewModel.userSession == nil {
                    dismiss()
                }
            }
        }
        .alert("Are you sure?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                viewModel.deleteAccount()
                navigateToHomePageView = true
            }
        } message: {
            Text("This action cannot be undone.")
        }
    }
}

// MARK: - Pet Card View
struct PetCardView: View {
    let pet: Pet // Ensure Pet conforms to Identifiable

    var body: some View {
        VStack {
            Image(systemName: "pawprint.circle.fill") // Replace with pet image 
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
//                .foregroundColor(.pink)
                .foregroundColor(.paleHazel)
            
            Text(pet.name)
                .font(.custom("Inter", size: 13, relativeTo: .caption))
                .foregroundColor(.primary)
                .kerning(2)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
    }
}

// MARK: - Pet Button View
struct AddPetCardView: View {
    var body: some View {
        VStack {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.paleHazel)
            
            Text("Add Pet")
                .font(.custom("Inter", size: 13, relativeTo: .caption))
                .foregroundColor(.primary)
                .kerning(2)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
    }
}

