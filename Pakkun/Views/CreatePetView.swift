//
//  CreatePetView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//

import SwiftUI

struct CreatePetView: View {
    @State private var name: String = ""
    @State private var date: String = ""
    @State private var zodiac: String = ""
    @State private var snack: String = ""
    @State private var ownerName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    let animalTypes = ["Bird", "Dog", "Cat", "Reptile", "Fish", "Small Pet"]
//    let descent = animalTypes.sorted(by: > )
//    let ascent = animalTypes.sorted(by: < )
    @State private var selectedAnimal: String = "Dog"
    
    let breeds = ["Beagle","Chihuahua", "Pug", "French Bulldog", "Golden Retriever"]
    @State private var selectedBreed: String = "Pug"
    
    var body: some View {
        ZStack {
            // Background color
            Color(.paleHazel)
//            Color(red: 0.95, green: 0.92, blue: 0.85)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Title
                Text("Create a Profile for your Furry Friend")
                    .kerning(2)
                    .font(.custom("Inter", size: 18, relativeTo: .title))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                // Image
                Image("") // replace image, add one in assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 1))
                
                // Form
                VStack(spacing: 15) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Date of Birth", text: $date)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Zodiac", text: $zodiac)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Favorite Snack", text: $snack)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack(spacing: 20) {
                        // Dropdown for Type of Animal
                        VStack(alignment: .leading) {
                            Text("Type of Animal")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("Type of Animal", selection: $selectedAnimal) {
                                ForEach(animalTypes, id: \.self) { animal in
                                    Text(animal)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.platinum))
                        }
                        
                        // Dropdown for Breed
                        VStack(alignment: .leading) {
                            Text("Breed")
                                .font(.caption)
                                .foregroundColor(.black)
                            Picker("Breed", selection: $selectedBreed) {
                                ForEach(breeds, id: \.self) { breed in
                                    Text(breed)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.platinum))
                        }
                    }
                    
                    TextField("Owner Name", text: $ownerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white))
//                .shadow(radius: 5)
                
                // Next Button
                Button(action: {
                    // Next action here
                }) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, minHeight: 44)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.95, green: 0.92, blue: 0.85)))
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

struct CreateAuthView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePetView()
    }
}
