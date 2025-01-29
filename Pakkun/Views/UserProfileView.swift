//
//  UserProfileView.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var navigateToCreatePetView = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.blueBell)
                    .edgesIgnoringSafeArea(.all)
                
                if let user = viewModel.currrentUser {
                    List {
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
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(.top, 4)
                                    
                                    Text(user.email)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Section("Pet Accounts") {
                            Button {
                                print("User clicked on pet profile")
                            } label: {
                                SettingRowView(imageName: "heart",
                                               title: "Pet's Profile",
                                               tintColor: Color(.systemPink))
                            }
                            Button {
                                navigateToCreatePetView = true
                                print("User wants to add a new pet")
                            } label: {
                                SettingRowView(imageName: "dog",
                                               title: "Add New Pet",
                                               tintColor: Color(.systemPink))
                            }
                        }
                        
                        Section("Settings") {
                            Button {
                                viewModel.SignOut()
                            } label: {
                                SettingRowView(imageName: "arrow.left.circle.fill",
                                               title: "Sign Out",
                                               tintColor: .pink)
                            }
                            Button {
                                print("User deletes account")
                            } label: {
                                SettingRowView(imageName: "xmark.circle.fill",
                                               title: "Delete Account",
                                               tintColor: .red)
                            }
                        }
                    }
                    .scrollContentBackground(.hidden) // Hides default List background
                    .background(Color.clear) // Keeps list transparent over ZStack
                    .navigationDestination(isPresented: $navigateToCreatePetView) {
                        CreatePetView()
                    }
                }
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
