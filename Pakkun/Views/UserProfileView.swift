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
    @State private var navigateToHomePageView = false
    @State private var showDeleteAlert = false
    @State private var deleteAction: DeleteAction? = nil // Determines which delete action is selected
    @State private var petToDelete: String? = nil // Will store pet id

    let pet: Pet

    enum DeleteAction {
        case deleteAccount
        case deletePet
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.blueBell)
                    .edgesIgnoringSafeArea(.all)

                if viewModel.userSession == nil {
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
                                        .foregroundColor(.black)

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
                                                PetCardView(pet: pet) {
                                                    deleteAction = .deletePet
                                                    petToDelete = pet.id
                                                    showDeleteAlert = true
                                                }
                                                .frame(width: 130, height: 100)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    Button(action: {
                                        petViewModel.resetPetData() 
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
                            }

                            SettingRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red) {
                                deleteAction = .deleteAccount
                                showDeleteAlert = true
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
        .alert(isPresented: $showDeleteAlert) {
            switch deleteAction {
            case .deleteAccount:
                return Alert(
                    title: Text("Are you sure?"),
                    message: Text("This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        Task {
                            await viewModel.deleteAccount()
                            navigateToHomePageView = true
                        }
                    },
                    secondaryButton: .cancel()
                )

            case .deletePet:
                return Alert(
                    title: Text("Delete Pet?"),
                    message: Text("Are you sure you want to delete this pet? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let petId = petToDelete, let userId = viewModel.currentUser?.id {
                            Task {
                                try await petViewModel.deletePet(petId: petId, userId: userId, viewModel: viewModel)
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )

            case .none:
                return Alert(title: Text("Unknown Error"))
            }
        }
    }
}


// MARK: - Pet Card View
struct PetCardView: View {
    let pet: Pet // Ensure Pet conforms to Identifiable
    let onDelete: () -> Void
    
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(systemName: "pawprint.circle.fill") // Replace with pet image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
    //                .foregroundColor(.pink)
                    .foregroundColor(.paleHazel)
                
                Button(action: {
                    onDelete()
                }) {
                    Image(systemName: "minus.circle") //minus.circle, minus
                        .resizable()
                        .foregroundColor(.pink)
                        .frame(width:20, height: 20)

                }
                .buttonStyle(PlainButtonStyle())
                .offset(x: 5, y: -5)
            }
            
            Text(pet.name)
                .font(.custom("Inter", size: 13, relativeTo: .caption))
                .foregroundColor(.black)
                .kerning(2)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.7)))
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
                .foregroundColor(.black)
                .kerning(2)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.7)))
    }
}

