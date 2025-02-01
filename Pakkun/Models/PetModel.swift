//
//  User.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//

import Foundation
import FirebaseFirestore

struct Pet: Codable {
    @DocumentID var id: String?
    var name: String
    @ServerTimestamp var dateOfBirth: Date? // Firestore handles Timestamp conversion
    var zodiac: String
    var favoriteSnack: String
    var selectedAnimal: String
    var selectedBreed: String
}
    
struct HealthInfo: Identifiable, Codable {
    let id: String
    let foodBrand: String
    let foodAmount: String
    let timesperday: String
    let walkDuration: String
    let selectedWeight: String
    }
    
struct PetMedicalInfo: Identifiable, Codable {
    let id: String
    let vetVisitDate: [String]
    let vaccinations: [String]
    let medications: [String]
    }

