//
//  User.swift
//  BugetExpense
//
//  Created by Kushani Abeysinghe on 2023-09-03.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let name : String
    let email : String

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: name) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}


extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, name: "Kushani", email: "test@gmai.com")
}
