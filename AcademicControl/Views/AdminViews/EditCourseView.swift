//
//  EditCourseView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 26/03/26.
//

import SwiftUI

struct EditCourseView: View {

    let course: Course
    @Bindable var viewModel: AdminViewModel

    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var selectedProfessor: User?
    @State private var selectedStudents: Set<String>

    init(course: Course, viewModel: AdminViewModel) {
        self.course = course
        self.viewModel = viewModel

        _name = State(initialValue: course.name)
        _selectedStudents = State(initialValue: Set(course.students))
        _selectedProfessor = State(initialValue: nil)
    }

    var body: some View {

        NavigationStack {
            Form {

                // MARK: - Name
                Section("Course Name") {
                    TextField("Name", text: $name)
                }

                // MARK: - Professor
                Section("Professor") {

                    Picker("Select Professor", selection: $selectedProfessor) {

                        ForEach(viewModel.professors) { professor in
                            Text(professor.name)
                                .tag(Optional(professor))
                        }
                    }
                    .pickerStyle(.menu)

                    if let selectedProfessor {
                        Text("Selected: \(selectedProfessor.name)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                // MARK: - Students
                Section("Students") {

                    ForEach(viewModel.users.filter { $0.role == .student }) { student in

                        Button {
                            toggleStudent(student.id)
                        } label: {
                            HStack {
                                Text(student.name)
                                Spacer()
                                if selectedStudents.contains(student.id) {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }

                // MARK: - Save
                Button("Save Changes") {

                    guard let professor = selectedProfessor else { return }

                    viewModel.updateCourse(
                        course: course,
                        name: name,
                        professor: professor,
                        students: Array(selectedStudents)
                    )

                    dismiss()
                }
            }
            .navigationTitle("Edit Course")
            .onAppear {
                // Set initial professor
                selectedProfessor = viewModel.users.first {
                    $0.id == course.professorId
                }
            }
        }
    }

    private func toggleStudent(_ id: String) {
        if selectedStudents.contains(id) {
            selectedStudents.remove(id)
        } else {
            selectedStudents.insert(id)
        }
    }
}

#Preview {
    EditCourseView(course: .testCourses[0], viewModel: .init())
}
