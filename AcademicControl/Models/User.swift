//
//  User.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import Foundation

struct User: Identifiable {

    enum Role: String, Codable {
        case admin
        case professor
        case student
    }

    let id: String
    var name: String
    var email: String
    var role: Role
}
