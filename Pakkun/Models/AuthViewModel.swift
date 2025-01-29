//
//  AuthViewModel.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
// having all functionality associated with authenticatiing our user. mkaing network calls

import Foundation
import Firebase
import FirebaseAuth

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //going to tell us wheater or not we have a user loogged in. when we open our app it knows whether or not to route us to the login flow or profile view. firebase user object
    @Published var currrentUser: User? // my user i created
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in...")
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        // print("Create User"
        do {
            // Create the user with email and password
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // After user is created, set the user session
            self.userSession = result.user
            
            // Create a User object to store in Firestore
            let user = userModel(id: result.user.uid, fullname: fullname, email: email)
            
            // Encode the user and save to Firestore
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    
    func SignOut() {
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        
    }
}
