//
//  CreatePetView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct CreatePetView: View {
    @StateObject var viewModel = CreatePetUserModel()
    //    @State private var name: String = ""
    //    @State private var date: String = ""
    //    @State private var zodiac: String = ""
    //    @State private var snack: String = ""
    //    @State private var ownerName: String = ""
    //    @State private var email: String = ""
    //    @State private var password: String = ""
    @State private var navigateToHealthInfo = false
    @Environment(\.dismiss) var dismiss
    
    let animalBreeds: [String: [String]] = [
        "Dog": ["Beagle", "Chihuahua", "Pug", "French Bulldog", "Golden Retriever"],
        "Cat": ["Persian", "Siamese", "Maine Coon", "Sphynx", "Bengal"],
        "Bird": ["Parrot", "Canary", "Cockatiel", "Finch"],
        "Reptile": ["Iguana", "Gecko", "Snake", "Turtle"],
        "Fish": ["Goldfish", "Betta", "Guppy", "Angelfish"],
        "Small Pet": ["Rabbit", "Guinea Pig", "Hamster", "Ferret"]
    ]
    
    @State private var selectedAnimal: String = "Dog"
    @State private var selectedBreed: String = "Pug"
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.blueBell)
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
                        TextField("Name", text: $viewModel.name)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        TextField("Date of Birth", text: $viewModel.date)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        TextField("Zodiac", text: $viewModel.zodiac)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        TextField("Favorite Snack", text: $viewModel.snack)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                        
                        // Animal & Breed Selection
                        HStack(spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Type of Animal")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Picker("Type of Animal", selection: $selectedAnimal) {
                                    ForEach(animalBreeds.keys.sorted(), id: \.self) { animal in
                                        Text(animal)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .onChange(of: selectedAnimal) {
                                    selectedBreed = animalBreeds[selectedAnimal]?.first ?? ""
                                }
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                
                                VStack(alignment: .leading) {
                                    Text("Breed")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Picker("Breed", selection: $selectedBreed) {
                                        ForEach(animalBreeds[selectedAnimal] ?? [], id: \.self) { breed in
                                            Text(breed)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(maxWidth: .infinity)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                                }
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                        
                        // Navigation Buttons
                        HStack(spacing: 20) {
                            Button {
                                dismiss()
                            } label: {
                                Text("Back")
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                            }
                            
                            Button {
                                navigateToHealthInfo = true
                            } label: {
                                Text("Next")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, minHeight: 44)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))

                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 20)
                    }
                    .padding()
                }
                .navigationDestination(isPresented: $navigateToHealthInfo) {
                    HealthInfoView(name: viewModel.name)
                }
            }
        }
    }
}
    
struct CreatePetView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePetView()
        }
    }
    

