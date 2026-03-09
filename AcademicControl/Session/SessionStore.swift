//
//  SessionStore.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import Foundation
import SwiftUI

@Observable
class SessionStore {

    var currentUser: User?

    func login(email: String, password: String) {

        // TODO: Firebase Authentication

        // Temporary bypass for UI development
        currentUser = User(
            id: "1",
            name: "Demo Student",
            email: email,
            role: .student
        )
    }

    func logout() {

        // TODO: Backend logout

        currentUser = nil
    }
}
