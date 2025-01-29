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
                        SectionView(title: "Vet Visits", items: $viewModel.vetVisitDate, placeholder: "Enter Vet Visit Date")
                        
                        // Vaccinations Section
                        SectionView(title: "Vaccinations", items: $viewModel.vaccinationDate, placeholder: "Enter Vaccination Name and Date")
                        
                        // Medications Section
                        SectionView(title: "Medications", items: $viewModel.medications, placeholder: "Enter Medication")
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
                        navigateToWelcomePage = true
                        print("Pet Successfully recorded")
                    } label: {
                        Text("Done")
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
        .navigationDestination(isPresented: $navigateToWelcomePage) {
            WelcomePageView()
        }
    }
}

// MARK: - Section View (With Delete Option)
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
                    
                    // DELETE BUTTON ("-")
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

struct PetMedicalHistory_Previews: PreviewProvider {
    static var previews: some View {
        PetMedicalHistoryView()
    }
}
