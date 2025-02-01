//
//  User.swift
//  Pakkun
//
//  Created by New Student on 1/23/25.
//

import Foundation

struct Pet: Codable, Identifiable {
    let id: String
    var name: String
    var dateOfBirth: String
    var zodiac: String
    var favoriteSnack: String
    var type: String
    var breed: String
    var healthInfo: HealthInfo
    var medicalHistory: PetMedicalHistory
}

struct HealthInfo: Codable {
    var foodBrand: String
    var foodAmount: String
    var timesPerDay: String
    var walkTimes: String
    var walkDuration: String
    var weight: String
}
struct PetMedicalHistory: Codable {
    var id: String // Firestore document ID
    var petId: String // The ID of the pet
    var vetVisitDates: [String]
    var vaccinationDates: [String]
    var medications: [String]
}
//struct User: Codable {
//    let id: String
//    var email: String
//    var pets: [Pet]
//}

