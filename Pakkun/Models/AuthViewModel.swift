//
//  AuthViewModel.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //going to tell us wheater or not we have a user loogged in. when we open our app it                                         knows whether or not to route us to the login flow or profile view. firebase user object
    @Published var currentUser: UserModel? // my user i created
    
    init() {
        self.userSession = Auth.auth().currentUser //if we have someone logged in it has a value, it's going to show us the profile view
        Task {
            await fetchUser() // going to try to fetch the user right away
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            // Create the user with email and password
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // After user is created, set the user session
            self.userSession = result.user
            
            // Create a User object to store in Firestore
            let user = UserModel(id: result.user.uid, fullname: fullname, email: email)
            
            // Encode the user and save to Firestore
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            await fetchUser() // we need to fetch the data that was just uploaded to firebase so it can be display on the screen
            
        } catch {
            print("Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    
    func SignOut() {
        do {
            try Auth.auth().signOut() //signout user on backend
            self.userSession = nil // wipes out user session and takes us back to home page
            self.currentUser = nil //wipes out current user data model
        } catch {
            print("Failed to sign out with error: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() async {
        guard let user = Auth.auth().currentUser else {
            print("No authenticated user found.")
            return
        }
        
        let userId = user.uid 
        
        do {
            try await Firestore.firestore().collection("users").document(userId).delete() // deletes use data from firestore
            print("Deleted user data from firestore")
            
            try await user.delete()
            
            await MainActor.run {
                self.userSession = nil
                self.currentUser = nil
            }
            print("User account deleted successfully.")
            
        } catch {
            print("Failed to delete user: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userRef = Firestore.firestore().collection("users").document(uid)
        let snapshot = try? await userRef.getDocument()
        
        if let userData = try? snapshot?.data(as: UserModel.self) {
            var user = userData
            
            do {
                let pets = try await fetchPetsData(forUserId: uid) // Fetch pets
                user.pets = pets  // Assign the fetched pets to the user model
                DispatchQueue.main.async {
                    self.currentUser = user  // Update the currentUser
                }
            } catch {
                print("Error fetching user data: \(error.localizedDescription)")
            }
        }
    }

private func fetchPetsData(forUserId userId: String) async throws -> [Pet] {
    let petRef = Firestore.firestore().collection("users").document(userId).collection("pets")
    let querySnapshot = try await petRef.getDocuments()
    return querySnapshot.documents.compactMap { try? $0.data(as: Pet.self) }
    }
    
    // fetch pet data
    func fetchPets(forUserId userId: String) async throws {
        guard !userId.isEmpty else {
            print("Error: User ID is empty")
            return
        }
        
        let petRef = Firestore.firestore().collection("users").document(userId).collection("pets")
        
        do {
            let querySnapshot = try await petRef.getDocuments()
            let pets: [Pet] = querySnapshot.documents.compactMap { document in
                do {
                    return try document.data(as: Pet.self) // decodes firestore docs into pet model
                } catch {
                    print("Error decoding pet document: \(error)")
                    return nil
                }
            }
            
            DispatchQueue.main.async {
                self.currentUser?.pets = pets
            }
        } catch {
            print("Error fetching pets: \(error.localizedDescription)")
        }
    }
    
}
