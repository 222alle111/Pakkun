//
//  UserProfileView.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        List {
            Section {
                HStack {
                    Text(userModel.MOCK_USER.initials)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.platinum)
                        .frame(width:72, height: 72)
                        .background(Color(.blueBell))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(userModel.MOCK_USER.fullname)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 4)
                        
                        Text(userModel.MOCK_USER.email)
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
                        print("User wants to add a new pet")
                    } label: {
                        SettingRowView(imageName: "heart",
                                        title: "Add New Pet",
                                        tintColor: Color(.systemPink))
                    }

                }
                Section("Settings") {
                    Button {
                        print("Sign out")
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
    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
