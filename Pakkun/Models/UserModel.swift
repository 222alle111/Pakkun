//
//  User.swift
//  Pakkun
//
//  Created by New Student on 1/28/25.
//

import Foundation

struct userModel: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter() //<- the object it's going to look at the fullname and divide it up into components and give back what we need from the user full name
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension userModel {
    static var MOCK_USER = userModel(id: NSUUID().uuidString, fullname: "Valeria Cruz", email: "testing@example.com")
}
