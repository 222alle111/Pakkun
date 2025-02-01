//
//  MedicalView.swift
//  Pakkun
//
//  Created by New Student on 1/24/25.
//

import SwiftUI

struct PetMedicalHistoryView: View {
//    @State private var vetVisitDate: [String] = [] // Store multiple vet visit dates
//    @State private var vaccinations: [String] = [] // Store multiple vaccination dates
//    @State private var medications: [String] = []// Store medications directly
    @State private var navigateToWelcomePage = false
    
    @Environment(\.dismiss) var dismiss // To dismiss and go back
    @EnvironmentObject var petViewModel: CreatePetUserModel
    @EnvironmentObject var viewModel: AuthViewModel
//    @State private var showErrorAlert = false
//    @State private var errorMessage: String = ""
    //    @StateObject var viewModel = CreatePetUserModel()
    
    let petId: String
    let userId: String
    
    var body: some View {
        ZStack {
            Color.blueBell
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Please Enter Your Pet’s Medical History")
                    .kerning(1)
                    .font(.custom("Inter", size: 26, relativeTo: .title))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 15) {
                        // Vet Visits Section
                        SectionView(title: "Vet Visits", items: $petViewModel.vetVisitDate, placeholder: "Enter Vet Visit Date")
                        
                        // Vaccinations Section
                        SectionView(title: "Vaccinations", items: $petViewModel.vaccinations, placeholder: "Enter Vaccination Name and Date")
                        
                        // Medications Section
                        SectionView(title: "Medications", items: $petViewModel.medications, placeholder: "Enter Medication")
                    }
                    .padding(.horizontal)
                }
                
                // Navigation Buttons
                HStack {
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
                    
                    Spacer()
                    
                    Button {
                        Task {
                            do {
                                try await petViewModel.saveMedicalHistory(petId: petId, userId: userId)
                            } catch {
                                print("Error saving pet: \(error.localizedDescription)")
                            }
                        }
                        navigateToWelcomePage = true
                        print("Pet Successfully recorded")
                    } label: {
                        Text("Create Pet")
                            .fontWeight(.semibold)
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }
        }
        .scrollContentBackground(.hidden)
        .navigationDestination(isPresented: $navigateToWelcomePage) {
            WelcomePageView()
        }
    }
//    private func 
}

// MARK: - Section View
struct SectionView: View {
    let title: String
    @Binding var items: [String]
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: {
                    items.append("") // Add new field
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Circle().fill(Color.platinum.opacity(0.2)))
                }
            }

            ForEach(items.indices, id: \.self) { index in
                HStack {
                    TextField(placeholder, text: $items[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                    
                    // DELETE BUTTON
                    if items.count > 1 { // Prevent deleting the last remaining item
                        Button(action: {
                            items.remove(at: index) // Remove the selected entry
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.pink)
                        }
                        .padding(.leading, 5)
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.2)))
    }
}

//struct PetMedicalHistory_Previews: PreviewProvider {
//    static var previews: some View {
//        PetMedicalHistoryView(petId: "123", userId: "12")
//    }
//}
