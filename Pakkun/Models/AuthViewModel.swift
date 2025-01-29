//
//  AuthViewModel.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
// having all functionality associated with authenticatiing our user. mkaing network calls

import Foundation
import Firebase
import FirebaseAuth


class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //going to tell us wheater or not we have a user loogged in. when we open our app it knows whether or not to route us to the login flow or profile view
    @Published var currrentUser: User? // my user i created
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        print("Sign in...")
    }
    
    func createUser(withEmail email: String, passowrd: String, fullname: String) async throws {
        print("Creat user")
    }
    
    func SignOut() {
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        
    }
}
