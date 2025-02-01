//
//  HealthInfoView.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//

import SwiftUI
import FirebaseFirestore

struct HealthInfoView: View {
    @State private var foodBrand = ""
    @State private var foodAmount = ""
    @State private var timesPerDay = ""
    @State private var walkTimes = ""
    @State private var walkDuration = ""
    @State private var selectedWeight = "5 lbs"

    @State private var navigateToRegisterPetMedical = false
//    @State private var navigateToCreatePet = false
    @State private var showErrorAlert = false
    @State private var errorMessage: String = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petViewModel: CreatePetUserModel
    @EnvironmentObject var viewModel: AuthViewModel
    
//    let name: String
    let petId: String
    let userId: String
        
    let weightOptions = ["5 lbs", "10 lbs", "11 lbs", "12 lbs", "13 lbs" ,"15 lbs", "20 lbs", "22 lbs", "23 lbs", "24 lbs", "25 lbs", "26 lbs", "27 lbs", "28 lbs", "29 lbs", "30 lbs"]
    
    var body: some View {
        ZStack {
            // Background color
            Color(.blueBell)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                VStack {
                        Text("Hi !") //\(name)
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
                    .font(.custom("Inter", size: 16, relativeTo: .body))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                // Health Info Form
                VStack(spacing: 15) {
                    HStack {
                        Text("Food Brand")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .lineLimit(nil)
                        TextField("e.g., Oxbow Essentials", text: $foodBrand)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Food Amount")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .lineLimit(nil)
                        TextField("e.g., 1/8 cups", text: $foodAmount)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    HStack {
                        Text("How Many Times Per Day")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .lineLimit(nil)
                        TextField("e.g., 3x a day", text: $timesPerDay)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    HStack {
                        Text("Walk Times Per Day?")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .lineLimit(nil)
                        TextField("e.g., 2", text: $walkTimes)
                            .frame(maxWidth: .infinity)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    HStack {
                        Text("For How Long?")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .lineLimit(nil)
                        TextField("e.g., 30 mins", text: $walkDuration)
                            .padding(5)
                            .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    
                    VStack(alignment: .leading) {
                        Text("How Much Does Your Pet Weigh?")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        Picker("Select Weight", selection: $selectedWeight) {
                            ForEach(weightOptions, id: \.self) { weight in
                                Text(weight)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(height: 120)
                        .clipped()
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.5)))
                
                // Navigation Buttons
                HStack {
                    Button {
//                        navigateToCreatePet = true
                        dismiss()
                    } label: {
                        Text("Back")
                            .fontWeight(.semibold)
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                    }
                    // Save and navigate
                    Button(action: {
                        if validateHealthInfo() {
                            navigateToRegisterPetMedical = true
                        } else {
                            showErrorAlert = true
                        }
                        Task {
                            if let userId = viewModel.currentUser?.id {
                                let petId = petViewModel.petId // Ensure we use petViewModel.petId
                                guard !petId.isEmpty else {
                                    print("Error: Pet ID is empty in HealthInfoView.")
                                    return
                                }
                                
                                do {
                                    try await petViewModel.saveHealthInfo(
                                        petId: petId,
                                        userId: userId,
                                        foodBrand: foodBrand,
                                        foodAmount: foodAmount,
                                        timesPerDay: timesPerDay,
                                        walkDuration: walkDuration,
                                        selectedWeight: selectedWeight
                                    )
                                    print("Saved pet health info")
                                    print("183")
                                } catch {
                                    print("Error saving pet health info: \(error.localizedDescription)")
                                }
                            } else {
                                print("Error: No current user available.")
                            }
                        }
                        print("saved health info")
//                        navigateToRegisterPetMedical = true
                    }) {
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
            .alert("Hi there!", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
            .scrollContentBackground(.hidden)
//            .navigationDestination(isPresented: $navigateToCreatePet) {
//                CreatePetView()
//            }
        }
        .scrollContentBackground(.hidden)
        .navigationDestination(isPresented: $navigateToRegisterPetMedical) {
            PetMedicalHistoryView(petId: petViewModel.petId, userId: userId)
                .environmentObject(petViewModel)
                .environmentObject(viewModel)
//                .environmentObject(petViewModel)
//                .environmentObject(AuthViewModel())
        }
    }
    // Validation
    private func validateHealthInfo() -> Bool {
        if foodBrand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Food brand cannot be empty."
            return false
        }
        if foodAmount.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Food amount cannot be empty."
            return false
        }
        if timesPerDay.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Times per day cannot be empty."
            return false
        }
        if walkTimes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Walk times per day cannot be empty."
            return false
        }
        if walkDuration.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "Walk duration cannot be empty."
            return false
        }
        if selectedWeight.isEmpty {
            errorMessage = "Please select a weight."
            return false
        }
        return true
    }
}

//struct HealthInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        HealthInfoView()
//            .environmentObject(CreatePetUserModel())
//            .environmentObject(AuthViewModel())
//    }
//}

