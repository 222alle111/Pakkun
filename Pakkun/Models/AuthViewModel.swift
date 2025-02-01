//
//  AuthViewModel.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
// having all functionality associated with authenticatiing our user. mkaing network calls

import Foundation
import Firebase
import FirebaseAuth

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //going to tell us wheater or not we have a user loogged in. when we open our app it knows whether or not to route us to the login flow or profile view. firebase user object
    @Published var currentUser: UserModel? // my user i created
    //    @Published var pets: [Pet] = [] // stores fetched pets
    
    init() {
        self.userSession = Auth.auth().currentUser //if we have someone logged in it has a value, it's going to show us the profile view
        
        Task {
            await fetchUser() // going to try to fetch the user right away
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        //        print("Sign in...")
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        // print("Create User"
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
            print("Error: \(error.localizedDescription)")
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
    
    //    func deleteAccount() {
    //
    //    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userRef = Firestore.firestore().collection("users").document(uid)
        let snapshot = try? await userRef.getDocument()
        
        if let userData = try? snapshot?.data(as: UserModel.self) {
            self.currentUser = userData
            do {
                try await fetchPets(forUserId: uid)
            } catch {
                print("error fetching user data: \(error.localizedDescription)")
            }
        }
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
            let _: [Pet] = querySnapshot.documents.compactMap { document in
                do {
                    return try document.data(as: Pet.self) // Automatically decodes Timestamps into date
                } catch {
                    print("Error decoding pet document: \(error)")
                    return nil
                }
            }
            
            // Update the user's pet list (if you have a property to store it)
            //            DispatchQueue.main.async {
            //                self.currentUser?.pets = pets
            //            }
            
        } catch {
            print("Error fetching pets: \(error.localizedDescription)")
        }
    }
}

