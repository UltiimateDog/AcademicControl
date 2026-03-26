//
//  EditCourseView.swift
//  AcademicControl
//

import SwiftUI

struct EditCourseView: View {

    let course: Course
    @Bindable var viewModel: AdminViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var selectedProfessor: User?
    @State private var selectedStudents: Set<String>
    @State private var scheduleItems: [ScheduleItem]
    @State private var showingAddSchedule = false

    init(course: Course, viewModel: AdminViewModel) {
        self.course = course
        self.viewModel = viewModel
        _name = State(initialValue: course.name)
        _selectedStudents = State(initialValue: Set(course.students))
        _selectedProfessor = State(initialValue: nil)
        _scheduleItems = State(initialValue: course.scheduleItems)
    }

    var body: some View {
        NavigationStack {
            Form {

                Section("Course Name") {
                    TextField("Name", text: $name)
                }

                Section("Professor") {
                    if viewModel.professors.isEmpty {
                        Text("No professors available")
                            .foregroundColor(.secondary)
                    } else {
                        Picker("Select Professor", selection: $selectedProfessor) {
                            ForEach(viewModel.professors) { professor in
                                Text(professor.name).tag(Optional(professor))
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }

                Section("Schedule") {
                    if scheduleItems.isEmpty {
                        Text("No schedule added")
                            .foregroundColor(.secondary)
                    }
                    ForEach(scheduleItems) { item in
                        VStack(alignment: .leading) {
                            Text(item.weekday.name)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(item.timeString)
                                .fontWeight(.medium)
                        }
                    }
                    .onDelete { indexSet in scheduleItems.remove(atOffsets: indexSet) }

                    Button("Add Schedule Item") { showingAddSchedule = true }
                }

                Section("Students") {
                    ForEach(viewModel.users.filter { $0.role == .student }) { student in
                        Button {
                            if selectedStudents.contains(student.id) {
                                selectedStudents.remove(student.id)
                            } else {
                                selectedStudents.insert(student.id)
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(student.name)
                                        .foregroundStyle(.primary)
                                    Text(student.email)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if selectedStudents.contains(student.id) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                        }
                    }
                }

                Button("Save Changes") {
                    guard let professor = selectedProfessor else { return }
                    viewModel.updateCourse(
                        course: course,
                        name: name,
                        professor: professor,
                        students: Array(selectedStudents),
                        scheduleItems: scheduleItems
                    )
                    dismiss()
                }
                .disabled(selectedProfessor == nil)
            }
            .navigationTitle("Edit Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showingAddSchedule) {
                AddScheduleItemView { newItem in
                    var item = newItem
                    item.courseName = name
                    scheduleItems.append(item)
                }
            }
            .onAppear {
                selectedProfessor = viewModel.users.first { $0.id == course.professorId }
            }
        }
    }
}

#Preview {
    EditCourseView(course: .testCourses[0], viewModel: .init())
}
