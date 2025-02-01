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
    @Published var dateOfBirth: Date = Date()
    @Published var zodiac: String = ""
    @Published var favoriteSnack: String = ""
    @Published var selectedAnimal: String = "Dog"
    @Published var selectedBreed: String = "Pug"
    @Published var petId: String = ""
    
    @Published var foodBrand = ""
    @Published var foodAmount = ""
    @Published var timesPerDay = ""
    @Published var walkTimes = ""
    @Published var walkDuration = ""
    @Published var selectedWeight = "5 lbs"
    
    @Published var vetVisitDate: [String] = []
    @Published var vaccinations: [String] = []
    @Published var medications: [String] = []
    
    let db = Firestore.firestore()
    
    // save pet
    func savePet(forUserId userId: String) async throws {// saves pet's info under a specific user's account
        guard !userId.isEmpty else {
            print("Error: User ID is empty.")
            return
        }
        do {
            let petId = UUID().uuidString // generates a new pet
            DispatchQueue.main.async {
                self.petId = petId
            }
            print("Generated petId: \(petId)")
//            let petId = UUID().uuidString // generates a new pet
//            self.petId = petId
            
            let petRef = db.collection("users").document(userId).collection("pets").document(petId) // pet will store in subcollection under users document
            
//            let petData: [String:] = [ // creates a dictionary
//                "id": petId,
//                "name": name,
//                "dateOfBirth": dateOfBirth,
//                "zodiac": zodiac,
//                "favoriteSnack": favoriteSnack,
//                "selectedAnimal": selectedAnimal,
//                "selectedBreed": selectedBreed,
//            ]
            try await petRef.setData([ // creates a dictionary
                "id": petId,
                "name": name,
                "dateOfBirth": Timestamp(date: dateOfBirth),
                "zodiac": zodiac,
                "favoriteSnack": favoriteSnack,
                "selectedAnimal": selectedAnimal,
                "selectedBreed": selectedBreed,
            ]) // save pet data to firestore
            print("Pet successfully saved with ID: \(petId)")
            print("Saving pet for userId: \(userId), petId: \(petId)")

//            
            try await saveHealthInfo(petId: petId,
                                     userId: userId,
                                     foodBrand: foodBrand,
                                     foodAmount: foodAmount,
                                     timesPerDay: timesPerDay,
                                     walkDuration: walkDuration,
                                     selectedWeight: selectedWeight)
            
            try await saveMedicalHistory(petId: petId, userId: userId)
            
        } catch {
            print("Failed to save pet: \(error.localizedDescription)")
        }
    }
    
    // save health info
    func saveHealthInfo(petId: String, userId: String, foodBrand: String, foodAmount: String, timesPerDay: String, walkDuration: String, selectedWeight: String) async throws {
        
        guard !userId.isEmpty, !petId.isEmpty else {
            print("Error: User ID or Pet ID is empty.")
            return
        }
//            let healthId = UUID().uuidString
            let healthRef = db.collection("users").document(userId).collection("pets").document(petId).collection("healthInfo").document("data") // petId to ensure one entry per per
        print("health info \(healthRef)")
        
            let healthData: [String: Any] = [
                "foodBrand": foodBrand,
                "foodAmount": foodAmount,
                "timesPerDay": timesPerDay,
                "walkDuration": walkDuration,
                "selectedWeight": selectedWeight
            ]
        do {
            print("health data: \(healthData)")
            
            try await healthRef.setData(healthData)

            print("Saving health info for petId: \(petId)")
        } catch {
            print("Failed to save health info: \(error.localizedDescription)")
        }
    }
    
    //save medical history
    func saveMedicalHistory(petId: String, userId: String) async throws {
        guard !userId.isEmpty, !petId.isEmpty else {
            print("Error: User ID or Pet ID is empty.")
            return
        }
        let medicalRef = db.collection("users").document(userId).collection("pets").document(petId).collection("medicalHistory").document("data")
        
        let medicalData: [String: Any] = [
            "vetVisitDates": vetVisitDate,
            "vaccinations": vaccinations,
            "medications": medications
        ]
        
        do {
            try await medicalRef.setData(medicalData)
            print("Saving medical history for petId: \(petId)")
        } catch {
            print("Failed to save medical history: \(error.localizedDescription)")
        }
    }
//    func saveMedicalHistory(forPetId petId: String, userId: String) async throws {
//        do {
////            let medicalId = UUID().uuidString
//            let medicalRef = db.collection("users").document(userId).collection("pets").document(petId).collection("medicalHistory").document()
//            
//            let medicalData: [String: Any] = [
//                "vetVisitDates": vetVisitDate,
//                "vaccinations": vaccinations,
//                "medications": medications
//            ]
//            
//            try await medicalRef.setData(medicalData)
//        } catch {
//            print("Failed to save medical history: \(error.localizedDescription)")
//        }
//        }
}
