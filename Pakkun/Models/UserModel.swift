//
//  User.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            
        }
    }
}
