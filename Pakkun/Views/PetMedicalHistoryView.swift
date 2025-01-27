//
//  MedicalView.swift
//  Pakkun
//
//  Created by New Student on 1/24/25.
//

import SwiftUI

struct PetMedicalHistoryView: View {
    
    @State private var vetVisitDate: [String] = [] // Store multiple vet visit dates
    @State private var vaccinationDate: [String] = [] // Store multiple vaccination dates
    @State private var medications: [String] = [] // Store medications directly
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
                            vetVisitDate.append("") // Add a new empty date field
                        })
                        ForEach(vetVisitDate.indices, id: \.self) { index in
                            TextField("Enter Vet Visit Date", text: $vetVisitDate[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }

                    // Vaccinations Section
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "Vaccinations", action: {
                            vaccinationDate.append("") // Add a new empty date field
                        })
                        ForEach(vaccinationDate.indices, id: \.self) { index in
                            TextField("Enter Vaccination Date", text: $vaccinationDate[index])
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }

                    // Medications Section
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader(title: "Medications", action: {
                            medications.append("") // Add a new empty medication field
                        })
                        ForEach(medications.indices, id: \.self) { index in
                            TextField("Enter Medication", text: $medications[index])
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
                            // Handle done action (optional)
                        }
                        .buttonStyle(.bordered)
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.5)))
                    }
                    .padding()
                }
                .padding()
            }
        }
    }
}

// Section Header with Title and "+" Button
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
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            }
        }
    }
}

struct PetMedicalHistory_Previews: PreviewProvider {
    static var previews: some View {
        PetMedicalHistoryView()
    }
}
