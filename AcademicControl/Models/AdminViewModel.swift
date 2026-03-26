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
    var courses: [Course] = []
    var isLoading = false
    var errorMessage: String? = nil

    var professors: [User] { users.filter { $0.role == .professor } }
    var students: [User]   { users.filter { $0.role == .student } }

    private let db = Firestore.firestore()

    // MARK: - Users

    func fetchUsers() {
        isLoading = true
        db.collection("users").getDocuments { snapshot, error in
            self.isLoading = false
            if let error = error { self.errorMessage = error.localizedDescription; return }
            self.users = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                let role = User.Role(rawValue: data["role"] as? String ?? "") ?? .student
                return User(id: doc.documentID,
                            name: data["name"] as? String ?? "",
                            email: data["email"] as? String ?? "",
                            role: role)
            } ?? []
        }
    }

    func updateRole(for user: User, to newRole: User.Role) {
        db.collection("users").document(user.id).updateData(["role": newRole.rawValue]) { error in
            if let error = error { self.errorMessage = error.localizedDescription; return }
            if let i = self.users.firstIndex(where: { $0.id == user.id }) {
                self.users[i].role = newRole
            }
        }
    }

    // MARK: - Courses

    func fetchCourses() {
        isLoading = true
        db.collection("courses").getDocuments { snapshot, error in
            self.isLoading = false
            if let error = error { self.errorMessage = error.localizedDescription; return }
            self.courses = snapshot?.documents.compactMap { doc in
                let data = doc.data()
                // scheduleItems guardados como array embebido en el documento
                let schedulesData = data["scheduleItems"] as? [[String: Any]] ?? []
                let schedules = schedulesData.compactMap { item -> ScheduleItem? in
                    guard let weekdayRaw = item["weekday"] as? Int,
                          let weekday = Weekday(rawValue: weekdayRaw)
                    else { return nil }
                    return ScheduleItem(
                        courseName: item["courseName"] as? String ?? (data["name"] as? String ?? ""),
                        weekday: weekday,
                        startHour: item["startHour"] as? Int ?? 0,
                        startMinute: item["startMinute"] as? Int ?? 0,
                        endHour: item["endHour"] as? Int ?? 0,
                        endMinute: item["endMinute"] as? Int ?? 0
                    )
                }
                return Course(
                    id: doc.documentID,
                    name: data["name"] as? String ?? "",
                    professorId: data["professorId"] as? String ?? "",
                    professorName: data["professorName"] as? String ?? "",
                    students: data["students"] as? [String] ?? [],
                    scheduleItems: schedules
                )
            } ?? []
        }
    }

    /// Crea un curso nuevo. scheduleItems se guardan como array embebido.
    func createCourse(
        name: String,
        professor: User?,
        selectedStudents: [User],
        scheduleItems: [ScheduleItem],
        completion: @escaping (Bool) -> Void
    ) {
        guard let professor = professor else {
            errorMessage = "Please select a professor"
            completion(false)
            return
        }

        let scheduleData: [[String: Any]] = scheduleItems.map { item in
            ["courseName": name,
             "weekday": item.weekday.rawValue,
             "startHour": item.startHour,
             "startMinute": item.startMinute,
             "endHour": item.endHour,
             "endMinute": item.endMinute]
        }

        let data: [String: Any] = [
            "name": name,
            "professorId": professor.id,
            "professorName": professor.name,
            "students": selectedStudents.map { $0.id },
            "scheduleItems": scheduleData
        ]

        db.collection("courses").addDocument(data: data) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.fetchCourses()
            completion(true)
        }
    }

    func updateCourse(
        course: Course,
        name: String,
        professor: User,
        students: [String],
        scheduleItems: [ScheduleItem]
    ) {
        let scheduleData: [[String: Any]] = scheduleItems.map { item in
            ["courseName": name,
             "weekday": item.weekday.rawValue,
             "startHour": item.startHour,
             "startMinute": item.startMinute,
             "endHour": item.endHour,
             "endMinute": item.endMinute]
        }

        db.collection("courses").document(course.id).updateData([
            "name": name,
            "professorId": professor.id,
            "professorName": professor.name,
            "students": students,
            "scheduleItems": scheduleData
        ]) { error in
            if let error = error { self.errorMessage = error.localizedDescription; return }
            self.fetchCourses()
        }
    }

    func addStudent(to course: Course, studentId: String) {
        db.collection("courses").document(course.id).updateData([
            "students": FieldValue.arrayUnion([studentId])
        ])
    }
}
