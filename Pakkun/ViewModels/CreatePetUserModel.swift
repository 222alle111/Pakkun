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
    
    @Published var currentPet: Pet? // stores the most recently created pet
    @Published var imagePath: String = "" // this will store the file path of the image
    
    let db = Firestore.firestore()
    
    // save pet
    func savePet(forUserId userId: String) async throws {// saves pet's info under a specific user's account
        guard !userId.isEmpty else {
            print("Error: User ID is empty.")
            return
        }
        
        do {
            let petId = UUID().uuidString // generates a new pet
            //            print("Generated petId: \(petId)")
            
            let petRef = db.collection("users").document(userId).collection("pets").document(petId) // pet will store in subcollection under users document
            
            let newPet = Pet(id: petId,
                             name: name,
                             dateOfBirth: dateOfBirth,
                             zodiac: zodiac,
                             favoriteSnack: favoriteSnack,
                             selectedAnimal: selectedAnimal,
                             selectedBreed: selectedBreed
            )
            
            try await petRef.setData([ // creates a dictionary // save pet data to firestore
                "id": petId,
                "name": name,
                "dateOfBirth": Timestamp(date: dateOfBirth),
                "zodiac": zodiac,
                "favoriteSnack": favoriteSnack,
                "selectedAnimal": selectedAnimal,
                "selectedBreed": selectedBreed,
            ])
            print("Pet successfully saved with ID: \(petId)")
            print("Saving pet for userId: \(userId), petId: \(petId)")
            
            await MainActor.run {
                self.petId = petId // petId is updated on the main thread
                self.currentPet = newPet
            }
            
            await MainActor.run {
                self.resetPetData()
            }
            
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
        let healthRef = db.collection("users").document(userId).collection("pets").document(petId).collection("healthInfo").document("healthData")
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
        let medicalRef = db.collection("users").document(userId).collection("pets").document(petId).collection("medicalHistory").document("medicalData")
        
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
    // delete pet 
    func deletePet(petId: String, userId: String, viewModel: AuthViewModel) async throws {
        guard !userId.isEmpty, !petId.isEmpty else {
            print("Error: User ID or Pet ID is empty.")
            return
        }
        let petRef = db.collection("users").document(userId).collection("pets").document(petId)
        let healthRef = petRef.collection("healthInfo")
        let medicalRef = petRef.collection("medicalHistory")
        
        
        do {
            let healthDocs = try await healthRef.getDocuments() // deletes doc from healthinfo
            for doc in healthDocs.documents {
                try await doc.reference.delete()
            }
            let medicalDocs = try await medicalRef.getDocuments() // deleted docs from medical history
            for doc in medicalDocs.documents {
                try await doc.reference.delete()
            }
            try await petRef.delete() // delete pet doc from firestore
            
            print("Successfully deleted petId: \(petId)")
            
            await MainActor.run {
                if let index = viewModel.currentUser?.pets.firstIndex(where: { $0.id == petId}) {
                    viewModel.currentUser?.pets.remove(at: index)
                }
            }
            
        } catch {
            print("Failed to delete pet: \(error.localizedDescription)")
        }
    }
    
    // takes UIImage, converts it to JPEG, and saves it in the app's Documents directory
    func saveImageToDocuments(image: UIImage, for petId: String) -> String? {
        let filename = "\(petId).jpg"
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)

        print("Saving image to path: \(fileURL.path)")

        // Check if directory exists
        let directory = fileURL.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directory.path) {
            print(" Directory does not exist. Creating now...")
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                print("Directory created.")
            } catch {
                print(" Failed to create directory: \(error.localizedDescription)")
                return nil
            }
        }

        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG data")
            return nil
        }

        do {
            try imageData.write(to: fileURL)
            print("Image successfully saved at: \(fileURL.path)")
            return fileURL.path
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return nil
        }
    }
//    func saveImageToDocuments(image: UIImage, for petId: String) -> String? {
//        // UUID().uuidString + ".jpg" generate a unique filename
//        let filename = "\(petId).jpg"// save the image with petId as the filename
//        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
//        
//        
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else { // Convert UIImage to Data
//            print("Failed to convert image to JPEG data")
//            return nil
//        }
//    
//        do {
//            try imageData.write(to: fileURL)
//            print("Successfully saved image for petId: \(petId) at \(fileURL.path)")
//            return fileURL.path //return the saved image path
//        } catch {
//            print("Error saving image: \(error)")
//            return nil
//        }
//    }
    // load the image in other views
    func loadImage(for petId: String) -> UIImage? {
        let filename = "\(petId).jpg" // looks for the image with petId filename
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        print("Trying to load image for petId: \(petId) from \(fileURL.path)")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            print("Loading image from: \(fileURL.path)")
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            print("No image found for petId: \(petId) at path: \(fileURL.path)")
            return nil
        }
    }
    
    func resetPetData() {
        self.name = ""
        self.dateOfBirth = Date()
        self.zodiac = ""
        self.favoriteSnack = ""
        self.selectedAnimal = "Dog"
        self.selectedBreed = "Pug"
        self.petId = ""
    
        self.foodBrand = ""
        self.foodAmount = ""
        self.timesPerDay = ""
        self.walkTimes = ""
        self.walkDuration = ""
        self.selectedWeight = "5 lbs"
    
        self.vetVisitDate = []
        self.vaccinations = []
        self.medications = []
        
        self.imagePath = ""
        }
}
