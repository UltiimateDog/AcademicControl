//
//  CreateCourseView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct CreateCourseView: View {

    @Bindable var viewModel: AdminViewModel
    @State private var showCreateSheet = false
    @State private var selectedCourse: Course? = nil

    // Form state
    @State private var newCourseName = ""
    @State private var selectedProfessor: User? = nil
    @State private var selectedStudents: Set<String> = []
    @State private var scheduleItems: [ScheduleItem] = []
    @State private var showAddSchedule = false

    var body: some View {
        List {
            Section {
                if viewModel.isLoading {
                    HStack { Spacer(); ProgressView(); Spacer() }
                } else {
                    ForEach(viewModel.courses) { course in
                        Button {
                            selectedCourse = course
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(course.name)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                    Text(course.professorName.isEmpty ? "No professor" : course.professorName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("\(course.students.count) Students")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(.accent.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            } header: {
                Text("\(viewModel.courses.count) Courses")
            }

            Button {
                showCreateSheet = true
            } label: {
                Text("Create new course")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.primaryC)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Courses")
        .onAppear {
            viewModel.fetchCourses()
            if viewModel.users.isEmpty { viewModel.fetchUsers() }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        // Edit existing course
        .sheet(item: $selectedCourse) { course in
            EditCourseView(course: course, viewModel: viewModel)
        }
        // Create new course
        .sheet(isPresented: $showCreateSheet) {
            createCourseSheet
        }
    }

    // MARK: - Create Course Sheet

    var createCourseSheet: some View {
        NavigationStack {
            Form {

                Section("Course name") {
                    TextField("e.g. Mathematics", text: $newCourseName)
                }

                Section("Professor") {
                    if viewModel.professors.isEmpty {
                        Text("No professors available — assign professor role first")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    } else {
                        ForEach(viewModel.professors) { professor in
                            HStack {
                                Text(professor.name)
                                Spacer()
                                if selectedProfessor?.id == professor.id {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture { selectedProfessor = professor }
                        }
                    }
                }

                Section("Students") {
                    if viewModel.students.isEmpty {
                        Text("No students available")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    } else {
                        ForEach(viewModel.students) { student in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(student.name)
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
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedStudents.contains(student.id) {
                                    selectedStudents.remove(student.id)
                                } else {
                                    selectedStudents.insert(student.id)
                                }
                            }
                        }
                    }
                }

                Section("Schedule") {
                    ForEach(scheduleItems) { item in
                        HStack {
                            Text(item.weekday.name).fontWeight(.medium)
                            Spacer()
                            Text(item.timeString).font(.caption).foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indexSet in scheduleItems.remove(atOffsets: indexSet) }

                    Button("+ Add time slot") { showAddSchedule = true }
                }
            }
            .navigationTitle("New Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { resetForm(); showCreateSheet = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { createCourse() }
                        .disabled(newCourseName.trimmingCharacters(in: .whitespaces).isEmpty || selectedProfessor == nil)
                }
            }
            .sheet(isPresented: $showAddSchedule) {
                AddScheduleItemView { newItem in
                    var item = newItem
                    item.courseName = newCourseName
                    scheduleItems.append(item)
                }
            }
        }
    }

    // MARK: - Actions

    private func createCourse() {
        let enrolledStudents = viewModel.students.filter { selectedStudents.contains($0.id) }
        viewModel.createCourse(
            name: newCourseName,
            professor: selectedProfessor,
            selectedStudents: enrolledStudents,
            scheduleItems: scheduleItems
        ) { success in
            if success { resetForm(); showCreateSheet = false }
        }
    }

    private func resetForm() {
        newCourseName = ""
        selectedProfessor = nil
        selectedStudents = []
        scheduleItems = []
    }
}

#Preview {
    NavigationStack {
        CreateCourseView(viewModel: .init())
    }
}
