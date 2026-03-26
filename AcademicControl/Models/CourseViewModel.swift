//
//  CourseViewModel.swift
//  AcademicControl
//
//

import Foundation
import FirebaseFirestore

@Observable
class CourseViewModel {

    var courses: [Course] = []
    var professors: [User] = []
    var students: [User] = []
    var isLoading = false
    var errorMessage: String? = nil

    private let db = Firestore.firestore()

    // MARK: - Fetch all courses

    func fetchCourses() {
        isLoading = true
        db.collection("courses").getDocuments { snapshot, error in
            self.isLoading = false
            if let error = error { self.errorMessage = error.localizedDescription; return }
            self.courses = snapshot?.documents.compactMap { doc in
                Self.parseCourse(doc: doc)
            } ?? []
        }
    }

    // MARK: - Fetch users (professors / students for pickers)

    func fetchUsers() {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error { self.errorMessage = error.localizedDescription; return }
            let all = snapshot?.documents.compactMap { doc -> User? in
                let data = doc.data()
                let role = User.Role(rawValue: data["role"] as? String ?? "") ?? .student
                return User(id: doc.documentID,
                            name: data["name"] as? String ?? "",
                            email: data["email"] as? String ?? "",
                            role: role)
            } ?? []
            self.professors = all.filter { $0.role == .professor }
            self.students   = all.filter { $0.role == .student }
        }
    }

    // MARK: - Fetch schedule for a professor

    func fetchScheduleForProfessor(uid: String, completion: @escaping ([ScheduleItem]) -> Void) {
        db.collection("courses")
            .whereField("professorId", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error { self.errorMessage = error.localizedDescription; completion([]); return }
                let items = snapshot?.documents.flatMap { doc -> [ScheduleItem] in
                    Self.parseCourse(doc: doc)?.scheduleItems ?? []
                } ?? []
                completion(items)
            }
    }

    // MARK: - Fetch schedule for a student

    func fetchScheduleForStudent(uid: String, completion: @escaping ([ScheduleItem]) -> Void) {
        db.collection("courses")
            .whereField("students", arrayContains: uid)
            .getDocuments { snapshot, error in
                if let error = error { self.errorMessage = error.localizedDescription; completion([]); return }
                let items = snapshot?.documents.flatMap { doc -> [ScheduleItem] in
                    Self.parseCourse(doc: doc)?.scheduleItems ?? []
                } ?? []
                completion(items)
            }
    }

    // MARK: - Fetch grades for a student

    func fetchGradesForStudent(uid: String, completion: @escaping ([Grade]) -> Void) {
        // Grades are stored as a subcollection under each course
        db.collection("courses")
            .whereField("students", arrayContains: uid)
            .getDocuments { snapshot, _ in
                let courseIds = snapshot?.documents.map { $0.documentID } ?? []
                guard !courseIds.isEmpty else { completion([]); return }

                let group = DispatchGroup()
                var allGrades: [Grade] = []

                for courseId in courseIds {
                    group.enter()
                    self.db.collection("courses").document(courseId)
                        .collection("grades")
                        .whereField("studentId", isEqualTo: uid)
                        .getDocuments { gradeSnapshot, _ in
                            let grades = gradeSnapshot?.documents.compactMap { doc -> Grade? in
                                let data = doc.data()
                                return Grade(id: doc.documentID,
                                             courseName: data["courseName"] as? String ?? "",
                                             studentName: data["studentName"] as? String ?? "",
                                             value: data["value"] as? Int ?? 0)
                            } ?? []
                            allGrades.append(contentsOf: grades)
                            group.leave()
                        }
                }

                group.notify(queue: .main) { completion(allGrades) }
            }
    }

    // MARK: - Private parser (shared by all fetch methods)

    private static func parseCourse(doc: DocumentSnapshot) -> Course? {
        let data = doc.data() ?? [:]
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
    }
}
