//
//  HealthInfoView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//

import SwiftUI

struct HealthInfoView: View {
    @State private var foodBrand = ""
    @State private var foodAmount = ""
    @State private var timesPerDay = ""
    @State private var walkTimes = ""
    @State private var walkDuration = ""
    @State private var selectedWeight = ""
    @State private var navigateToCreatePet = false
    @State private var navigateToRegisterPetMedical = false
    
    let name: String
        
    let weightOptions = ["5 lbs", "10 lbs", "12 lbs"]
    
    var body: some View {
        ZStack {
            // Background color
            Color(.paleHazel)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                VStack {
                        Text("Hi \(name)!")
                            .kerning(5)
                            .font(.custom("Inter", size: 30, relativeTo: .title))
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)

//                    Spacer(minLength: 10)
                
                // Pet image
                //                    Image("") //
                //                        .resizable()
                //                        .scaledToFit()
                //                        .frame(width: 150, height: 150)
                //                        .clipShape(Circle())
                //                        .overlay(Circle().stroke(Color.black, lineWidth: 1))
                
                Text("Please log your pet’s activities, food log, and medical visits.")
                    .kerning(1)
                    .font(.custom("Inter", size: 14, relativeTo: .body))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
//                Text("Please fill out the Health Information for Princess:")
//                    .kerning(1)
//                    .font(.custom("Inter", size: 13, relativeTo: .title))
//                    .foregroundColor(.black)
//                    .padding(.top, 10)
                
                // Health Info Form
                VStack(spacing: 15) {
                    HStack {
                        Text("Food Brand")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        TextField("e.g., Oxbow Essentials", text: $foodBrand)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .lineLimit(nil)
                    }
                    
                    HStack {
                        Text("Food Amount Eaten Per Meal")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        TextField("e.g., 1/8 cups", text: $foodAmount)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .lineLimit(nil)
                    }
                    
                    HStack {
                        Text("How Many Times Per Day")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        TextField("e.g., 3x a day", text: $timesPerDay)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .lineLimit(nil)
                    }
                    
                    HStack {
                        Text("How many times a day you walk your pet?")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        TextField("e.g., 2", text: $walkTimes)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .lineLimit(nil)
                    }
                    
                    HStack {
                        Text("For how long? (e.g., 30 mins)")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        TextField("e.g., 30 mins", text: $walkDuration)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(maxWidth: .infinity)
                            .lineLimit(nil)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("How much does your pet weigh?")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        Picker("Select Weight", selection: $selectedWeight) {
                            ForEach(weightOptions, id: \.self) { weight in
                                Text(weight)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                
                // Navigation Buttons
                HStack {
                    Button(action: {
                        navigateToCreatePet = true
                    }) {
                        Text("Back")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                    }
                    Button(action: {
                        // Save and navigate
                        navigateToRegisterPetMedical = true
                    }) {
                        Text("Next")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
            }
        }
        .navigationDestination(isPresented: $navigateToCreatePet) {
                CreatePetView()
        }
        .navigationDestination(isPresented: $navigateToRegisterPetMedical) {
            PetMedicalHistoryView()
        }
    }
}

    //#Preview {
    //    HealthInfoView()
    //}
struct HealthInfoView_Previews: PreviewProvider {
    static var previews: some View {
        HealthInfoView(name: "Princess")
    }
}

