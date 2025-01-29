//
//  MedicalView.swift
//  Pakkun
//
//  Created by New Student on 1/24/25.
//

import SwiftUI

struct PetMedicalHistoryView: View {
    @StateObject var viewModel = CreatePetUserModel()
    @State private var navigateToWelcomePage = false
    
    //    @State private var vetVisitDate: [String] = [] // Store multiple vet visit dates
    //    @State private var vaccinationDate: [String] = [] // Store multiple vaccination dates
    //    @State private var medications: [String] = [] // Store medications directly
    @Environment(\.dismiss) var dismiss // To dismiss and go back
    
    var body: some View {
        ZStack {
            Color.paleHazel
                .edgesIgnoringSafeArea(.all)
            
            // Main content
            NavigationView {
                VStack(spacing: 20) {
                    // Title
                    Text("Please Enter your Pet’s Medical History")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding()
                    
                    // Vet Visits Section
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "Vet Visits", action: {
                            viewModel.vetVisitDate.append("") // Add a new empty date field
                        })
                        ForEach(viewModel.vetVisitDate.indices, id: \.self) { index in
                            TextField("Enter Vet Visit Date", text: $viewModel.vetVisitDate[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Vaccinations Section
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "Vaccinations", action: {
                            viewModel.vaccinationDate.append("") // Add a new empty date field
                        })
                        ForEach(viewModel.vaccinationDate.indices, id: \.self) { index in
                            TextField("Enter Vaccination Date", text: $viewModel.vaccinationDate[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Medications Section
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "Medications", action: {
                            viewModel.medications.append("") // Add a new empty medication field
                        })
                        ForEach(viewModel.medications.indices, id: \.self) { index in
                            TextField("Enter Medication", text: $viewModel.medications[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    
                    // Buttons
                    HStack {
                        Button("Back") {
                            dismiss() // This dismisses the current view and goes back
                        }
                        .buttonStyle(.bordered)
                        //                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                        
                        Spacer()
                        
                        Button("Done") {
                            //add pet successfully register here
                            // connect welcome page view
                            navigateToWelcomePage = true
                        }
                        .buttonStyle(.bordered)
                        //                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                    }
                    .padding()
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToWelcomePage) {
                WelcomePageView()
            }
        }
    }
    
    struct SectionHeader: View {
        let title: String
        let action: () -> Void
        
        var body: some View {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Button(action: action) {
                    Image(systemName: "plus")
                        .foregroundColor(.black)
                        .padding(8)
                        .background(Circle().fill(Color.platinum.opacity(0.2)))
                }
            }
        }
    }
}

struct PetMedicalHistory_Previews: PreviewProvider {
    static var previews: some View {
        PetMedicalHistoryView()
    }
}
