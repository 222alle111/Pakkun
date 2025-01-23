//
//  AuthenticationManager.swift
//  Pakkun
//
//  Created by New Student on 1/22/25.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoURL: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoURL = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    //this func gets a user that's already authenticated
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    func signOut() throws { // its synchronous so it's not async, its going to sign out locally we cont need to ping the server it happens immediately. If it doesn't throw an error, mean they successfully signed out.
        try Auth.auth().signOut()
    }
    
    
    
//
        //This func creates a user
        @discardableResult // meaning theres a result value coming from here but might not always use it
        func createUser(email: String, password: String) async throws -> AuthDataResultModel {
            let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        }
        
        @discardableResult
        func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
            let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
            return AuthDataResultModel(user: authDataResult.user)
        }
        
        func resetPassword(email: String) async throws {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        }
        
        func updatePassword(password: String) async throws {
            guard let user = Auth.auth().currentUser else {
                throw NSError(domain: "AuthenticationError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            }
            
            try await user.updatePassword(to: password)
        }
    }
    
// MARK: Sign In SSO
extension AuthenticationManager {
    
    @discardableResult
    func signInWithGoogle(tokens: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: tokens.idToken, accessToken: tokens.accessToken)
            // we want to sign in with firebase with the credential
            return try await signIn(credential: credential)
        }
        
        func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
            let authDataResult = try await Auth.auth().signIn(with: credential)
            return AuthDataResultModel(user: authDataResult.user)
        }
    }

