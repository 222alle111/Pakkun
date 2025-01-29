//
//  CreatePetUserModel.swift
//  Pakkun
//
//  Created by New Student on 1/27/25.
//

import Foundation
import Firebase
import FirebaseFirestore

class CreatePetUserModel: ObservableObject {
    @Published var name: String = ""
    @Published var date: String = ""
    @Published var zodiac: String = ""
    @Published var snack: String = ""
//    @Published var ownerName: String = ""
    @Published var foodBrand = ""
    @Published var foodAmount = ""
    @Published var timesPerDay = ""
    @Published var walkTimes = ""
    @Published var walkDuration = ""
    @Published var selectedWeight = ""
    @Published var vetVisitDate: [String] = [] // Store multiple vet visit dates
    @Published var vaccinationDate: [String] = [] // Store multiple vaccination dates
    @Published var medications: [String] = [] // Store medications directly
    
    func saveUser(user: User) async throws {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.id)
        
        // Save the `User` object
        try await userRef.setData([
            "id": user.id,
            "email": user.email,
            "pets": user.pets.map { pet in
                return [
                    "id": pet.id,
                    "name": pet.name,
                    "dateOfBirth": pet.dateOfBirth,
                    "zodiac": pet.zodiac,
                    "favoriteSnack": pet.favoriteSnack,
                    "type": pet.type,
                    "breed": pet.breed,
//                    "ownerName": pet.ownerName,
                    "healthInfo": [
                        "foodBrand": pet.healthInfo.foodBrand,
                        "foodAmount": pet.healthInfo.foodAmount,
                        "timesPerDay": pet.healthInfo.timesPerDay,
                        "walkTimes": pet.healthInfo.walkTimes,
                        "walkDuration": pet.healthInfo.walkDuration,
                        "weight": pet.healthInfo.weight
                    ],
                    "medicalHistory": [
                        "id": pet.medicalHistory.id,
                        "petId": pet.medicalHistory.petId,
                        "vetVisitDates": pet.medicalHistory.vetVisitDates,
                        "vaccinationDates": pet.medicalHistory.vaccinationDates,
                        "medications": pet.medicalHistory.medications
                    ]
                ]
            }
        ])
    }
}
