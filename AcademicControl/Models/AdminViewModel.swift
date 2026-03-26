//
//  AdminViewModel.swift
//  AcademicControl
//
//  Created by Emiliano Ruíz Plancarte on 25/03/26.
//

import Foundation
import FirebaseFirestore

@Observable
class AdminViewModel {

    var users: [User] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil

    private let db = Firestore.firestore()

    // MARK: - Fetch all users from Firestore
    func fetchUsers() {
        isLoading = true
        db.collection("users").getDocuments { snapshot, error in
            self.isLoading = false
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            self.users = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                let roleString = data["role"] as? String ?? "student"
                let role = User.Role(rawValue: roleString) ?? .student
                return User(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    role: role
                )
            } ?? []
        }
    }

    // MARK: - Update role in Firestore
    func updateRole(for user: User, to newRole: User.Role) {
        db.collection("users").document(user.id).updateData([
            "role": newRole.rawValue
        ]) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            // Update local array so UI reflects change immediately
            if let index = self.users.firstIndex(where: { $0.id == user.id }) {
                self.users[index].role = newRole
            }
        }
    }
}
