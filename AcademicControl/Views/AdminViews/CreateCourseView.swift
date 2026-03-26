//
//  CreateCourseView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct CreateCourseView: View {

    @State private var viewModel = CourseViewModel()
    @State private var showCreateSheet = false

    // Sheet form state
    @State private var newCourseName = ""
    @State private var selectedProfessor: User? = nil
    @State private var selectedStudents: Set<String> = []
    @State private var scheduleItems: [ScheduleItem] = []
    @State private var showAddSchedule = false

    // New schedule item form
    @State private var newWeekday: Weekday = .monday
    @State private var newStartHour: Int = 8
    @State private var newStartMinute: Int = 0
    @State private var newEndHour: Int = 9
    @State private var newEndMinute: Int = 0

    var body: some View {
        List {
            Section {
                if viewModel.isLoading {
                    HStack { Spacer(); ProgressView(); Spacer() }
                } else {
                    ForEach(viewModel.courses) { course in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(course.name)
                                    .fontWeight(.medium)
                                Text(course.professorName.isEmpty ? "No professor" : course.professorName)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 4)
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
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Courses")
        .onAppear {
            viewModel.fetchCourses()
            viewModel.fetchUsers()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .sheet(isPresented: $showCreateSheet) {
            createCourseSheet
        }
    }

    // MARK: - Create Course Sheet

    var createCourseSheet: some View {
        NavigationStack {
            Form {

                // Course name
                Section("Course name") {
                    TextField("e.g. Mathematics", text: $newCourseName)
                }

                // Professor picker
                Section("Professor") {
                    if viewModel.professors.isEmpty {
                        Text("No professors available")
                            .foregroundColor(.secondary)
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
                            .onTapGesture {
                                selectedProfessor = professor
                            }
                        }
                    }
                }

                // Students picker
                Section("Students") {
                    if viewModel.students.isEmpty {
                        Text("No students available")
                            .foregroundColor(.secondary)
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

                // Schedule items
                Section("Schedule") {
                    ForEach(scheduleItems) { item in
                        HStack {
                            Text(item.weekday.name)
                                .fontWeight(.medium)
                            Spacer()
                            Text(item.timeString)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Button("+ Add time slot") {
                        showAddSchedule = true
                    }
                }

            }
            .navigationTitle("New Course")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        resetForm()
                        showCreateSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        createCourse()
                    }
                    .disabled(newCourseName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .sheet(isPresented: $showAddSchedule) {
                addScheduleSheet
            }
        }
    }

    // MARK: - Add Schedule Sheet

    var addScheduleSheet: some View {
        NavigationStack {
            Form {
                Section("Day") {
                    Picker("Weekday", selection: $newWeekday) {
                        ForEach(Weekday.allCases) { day in
                            Text(day.name).tag(day)
                        }
                    }
                    .pickerStyle(.wheel)
                }
                Section("Start time") {
                    Stepper("Hour: \(newStartHour):00", value: $newStartHour, in: 6...22)
                    Stepper("Minute: \(String(format: "%02d", newStartMinute))", value: $newStartMinute, in: 0...59, step: 15)
                }
                Section("End time") {
                    Stepper("Hour: \(newEndHour):00", value: $newEndHour, in: 6...22)
                    Stepper("Minute: \(String(format: "%02d", newEndMinute))", value: $newEndMinute, in: 0...59, step: 15)
                }
            }
            .navigationTitle("Add time slot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { showAddSchedule = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let item = ScheduleItem(
                            courseName: newCourseName,
                            weekday: newWeekday,
                            startHour: newStartHour,
                            startMinute: newStartMinute,
                            endHour: newEndHour,
                            endMinute: newEndMinute
                        )
                        scheduleItems.append(item)
                        showAddSchedule = false
                    }
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
            if success {
                resetForm()
                showCreateSheet = false
            }
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
        CreateCourseView()
    }
}
