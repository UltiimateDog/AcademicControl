//
//  CreateCourseView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct CreateCourseView: View {

<<<<<<< HEAD
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
=======
    @State private var name = ""
    @State private var selectedProfessor: User?
    
    @State private var showCreateSheet = false
    
    @State private var selectedCourse: Course?
    
    @Bindable var viewModel: AdminViewModel
>>>>>>> 44630298a03e97b0433bc6702af16b6d2b91f93d

    var body: some View {
        List {
            Section {
<<<<<<< HEAD
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
=======

                ForEach(viewModel.courses) { course in

                    Button {
                        selectedCourse = course
                    } label: {
                        HStack {

                            VStack(alignment: .leading, spacing: 4) {

                                Text(course.name)
                                    .fontWeight(.medium)

                                Text(course.professorName)
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
>>>>>>> 44630298a03e97b0433bc6702af16b6d2b91f93d
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
<<<<<<< HEAD
        .onAppear {
            viewModel.fetchCourses()
            viewModel.fetchUsers()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
=======
        .sheet(item: $selectedCourse) { course in
            EditCourseView(course: course, viewModel: viewModel)
>>>>>>> 44630298a03e97b0433bc6702af16b6d2b91f93d
        }
        .sheet(isPresented: $showCreateSheet) {
            createCourseSheet
        }
    }

    // MARK: - Create Course Sheet

    var createCourseSheet: some View {
        NavigationStack {
            Form {

<<<<<<< HEAD
                // Course name
                Section("Course name") {
                    TextField("e.g. Mathematics", text: $newCourseName)
=======
                TextField("Course name", text: $name)
                
                Section("Professor") {

                    if viewModel.professors.isEmpty {
                        
                        Text("No professors available")
                            .foregroundColor(.secondary)
                        
                    } else {
                        
                        Picker("Select Professor", selection: $selectedProfessor) {
                            
                            Text("None")
                                .tag(User?.none)
                            
                            
                            ForEach(viewModel.professors) { professor in
                                Text(professor.name)
                                    .tag(Optional(professor))
                            }
                            
                            
                        }
                        .pickerStyle(.menu)
                        
                    }
                    
                    if let selectedProfessor {
                        Text("Selected: \(selectedProfessor.name)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
>>>>>>> 44630298a03e97b0433bc6702af16b6d2b91f93d
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

<<<<<<< HEAD
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
=======
                    guard !name.isEmpty,
                          let professor = selectedProfessor else {
                        return
                    }

                    viewModel.createCourse(name: name, professor: professor)

                    // Reset UI
                    name = ""
                    selectedProfessor = nil
                    showCreateSheet = false
>>>>>>> 44630298a03e97b0433bc6702af16b6d2b91f93d
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
<<<<<<< HEAD
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
=======
        .onAppear {
            if viewModel.users.isEmpty {
                viewModel.fetchUsers()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
>>>>>>> 44630298a03e97b0433bc6702af16b6d2b91f93d
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
<<<<<<< HEAD
    NavigationStack {
        CreateCourseView()
    }
=======
    CreateCourseView(viewModel: .init())
>>>>>>> 44630298a03e97b0433bc6702af16b6d2b91f93d
}
