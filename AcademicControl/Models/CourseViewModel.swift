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
                    students: [],
                    scheduleItems: [] // <--- Agregamos esta línea para corregir el error
                )
            } ?? []
        }
    }

    // MARK: - Fetch professors and students (for pickers)
    func fetchUsers() {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            let allUsers = snapshot?.documents.compactMap { doc -> User? in
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
            self.professors = allUsers.filter { $0.role == .professor }
            self.students = allUsers.filter { $0.role == .student }
        }
    }

    // MARK: - Create course and assign professor + students
    func createCourse(
        name: String,
        professor: User?,
        selectedStudents: [User],
        scheduleItems: [ScheduleItem],
        completion: @escaping (Bool) -> Void
    ) {
        let courseRef = db.collection("courses").document()

        var data: [String: Any] = [
            "name": name,
            "professorId": professor?.id ?? "",
            "professorName": professor?.name ?? ""
        ]

        courseRef.setData(data) { error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }

            let group = DispatchGroup()

            // Save students as subcollection
            for student in selectedStudents {
                group.enter()
                courseRef.collection("students").document(student.id).setData([
                    "studentId": student.id,
                    "name": student.name,
                    "email": student.email
                ]) { _ in group.leave() }
            }

            // Save schedule items as subcollection
            for item in scheduleItems {
                group.enter()
                courseRef.collection("scheduleItems").document().setData([
                    "courseName": name,
                    "weekday": item.weekday.rawValue,
                    "startHour": item.startHour,
                    "startMinute": item.startMinute,
                    "endHour": item.endHour,
                    "endMinute": item.endMinute
                ]) { _ in group.leave() }
            }

            group.notify(queue: .main) {
                self.fetchCourses()
                completion(true)
            }
        }
    }

    // MARK: - Fetch schedule for a professor
    func fetchScheduleForProfessor(uid: String, completion: @escaping ([ScheduleItem]) -> Void) {
        db.collection("courses")
            .whereField("professorId", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion([])
                    return
                }
                let courseIds = snapshot?.documents.map { $0.documentID } ?? []
                self.fetchScheduleItems(for: courseIds, completion: completion)
            }
    }

    // MARK: - Fetch schedule for a student
    func fetchScheduleForStudent(uid: String, completion: @escaping ([ScheduleItem]) -> Void) {
        // Find all courses where this student is in the students subcollection
        db.collection("courses").getDocuments { snapshot, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion([])
                return
            }
            let allCourseIds = snapshot?.documents.map { $0.documentID } ?? []
            let group = DispatchGroup()
            var enrolledCourseIds: [String] = []

            for courseId in allCourseIds {
                group.enter()
                self.db.collection("courses").document(courseId)
                    .collection("students").document(uid)
                    .getDocument { doc, _ in
                        if doc?.exists == true {
                            enrolledCourseIds.append(courseId)
                        }
                        group.leave()
                    }
            }

            group.notify(queue: .main) {
                self.fetchScheduleItems(for: enrolledCourseIds, completion: completion)
            }
        }
    }

    // MARK: - Fetch grades for a student
    func fetchGradesForStudent(uid: String, completion: @escaping ([Grade]) -> Void) {
        db.collection("courses").getDocuments { snapshot, _ in
            let courseIds = snapshot?.documents.map { $0.documentID } ?? []
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
                            return Grade(
                                id: doc.documentID,
                                courseName: data["courseName"] as? String ?? "",
                                studentName: data["studentName"] as? String ?? "",
                                value: data["value"] as? Int ?? 0
                            )
                        } ?? []
                        allGrades.append(contentsOf: grades)
                        group.leave()
                    }
            }

            group.notify(queue: .main) {
                completion(allGrades)
            }
        }
    }

    // MARK: - Private helper: fetch scheduleItems for a list of courseIds
    private func fetchScheduleItems(for courseIds: [String], completion: @escaping ([ScheduleItem]) -> Void) {
        guard !courseIds.isEmpty else {
            completion([])
            return
        }
        let group = DispatchGroup()
        var allItems: [ScheduleItem] = []

        for courseId in courseIds {
            group.enter()
            db.collection("courses").document(courseId)
                .collection("scheduleItems")
                .getDocuments { snapshot, _ in
                    let items = snapshot?.documents.compactMap { doc -> ScheduleItem? in
                        let data = doc.data()
                        guard
                            let weekdayInt = data["weekday"] as? Int,
                            let weekday = Weekday(rawValue: weekdayInt)
                        else { return nil }
                        return ScheduleItem(
                            courseName: data["courseName"] as? String ?? "",
                            weekday: weekday,
                            startHour: data["startHour"] as? Int ?? 0,
                            startMinute: data["startMinute"] as? Int ?? 0,
                            endHour: data["endHour"] as? Int ?? 0,
                            endMinute: data["endMinute"] as? Int ?? 0
                        )
                    } ?? []
                    allItems.append(contentsOf: items)
                    group.leave()
                }
        }

        group.notify(queue: .main) {
            completion(allItems)
        }
    }
}
