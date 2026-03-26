//
//  ProffesorViewModel.swift
//  AcademicControl
//
//  Created by Rafael on 26/03/26.
//

import Foundation
import FirebaseFirestore

@Observable
class ProfessorViewModel {

    var courses: [Course] = []
    var isLoading = false
    var errorMessage: String? = nil

    private let db = Firestore.firestore()

    func fetchCourses(professorId: String) {
        isLoading = true
        db.collection("courses")
            .whereField("professorId", isEqualTo: professorId)
            .getDocuments { snapshot, error in
                self.isLoading = false
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                self.courses = snapshot?.documents.compactMap { doc in
                    let data = doc.data()
                    return Course(
                        id: doc.documentID,
                        name: data["name"] as? String ?? "",
                        professorId: data["professorId"] as? String ?? "",
                        professorName: data["professorName"] as? String ?? "",
                        students: data["students"] as? [String] ?? [],
                        scheduleItems: []           // ← agregado
                    )
                } ?? []
            }
    }
}
