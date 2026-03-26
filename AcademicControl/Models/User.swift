//
//  User.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import Foundation

struct User: Identifiable, Hashable {

    enum Role: String, Codable {
        case admin
        case professor
        case student
    }

    let id: String
    var name: String
    var email: String
    var role: Role
    
    static let testUsers: [User] = [
        User(id: "1", name: "Alice", email: "alice@mail.com", role: .student),
        User(id: "2", name: "Bob", email: "bob@mail.com", role: .professor),
        User(id: "3", name: "Carol", email: "carol@mail.com", role: .student),
        User(id: "4", name: "David", email: "david@mail.com", role: .student),
        User(id: "5", name: "Eva", email: "eva@mail.com", role: .professor)
    ]
}
