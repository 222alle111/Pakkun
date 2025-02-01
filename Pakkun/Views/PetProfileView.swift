//
//  ProfileView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//
import SwiftUI

struct PetProfileView: View {
//    @State private var navigateToSettingView = false
    
    var body: some View {
        ZStack {
            Color.blueBell // Light blue background
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Top Bar with Side Button
                HStack {
                    Spacer()
                    Button(action: {
//                        navigateToSettingView = true
                        print("Side Menu Tapped") // Add action here
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .padding()
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal)
                
                // **Profile Image and Name**
                VStack(spacing: 10) {
                    Image("Pug") // Replace with your actual image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 5)
                    
                    Text("Hi ") // \(name) from createpetusermodel
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.top, -20) // Moves it lower
                
                // **Info Box**
                VStack(alignment: .center, spacing: 5) { //Have to import createPetUserModel()
                    Text("DOB: 03/19/2019")
                    Text("Breed: Pug")
                    Text("Zodiac: Pisces")
                    Text("Favorite Snack: Bacon")
                }
                .font(.subheadline)
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color(red: 0.96, green: 0.96, blue: 0.91)))
                .padding(.horizontal)
                
                Spacer()
                
                // Centered Button Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    FeatureButton(icon: "pawprint", label: "Track Activity")
                    FeatureButton(icon: "stethoscope", label: "Medical History")
                    FeatureButton(icon: "carrot", label: "Food Logs")
                    FeatureButton(icon: "person.3", label: "Play with Friends")
                }
                .padding(.bottom, 40) // Moves it lower
                
            }
        }
        .scrollContentBackground(.hidden)
//        .navigationDestination(isPresented: $navigateToSettingView ) {
//            SettingView(showSignInView: $navigateToSettingView)
        }
    }
//}

// **Custom Button Component**
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
            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.platinum, lineWidth: 1))
        }
    }
}
struct PetProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PetProfileView()
    }
}
