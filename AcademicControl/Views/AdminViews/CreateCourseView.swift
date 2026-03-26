//
//  CreateCourseView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct CreateCourseView: View {

    @State private var name = ""
    
    @State private var showCreateSheet = false
    
    @Binding var viewModel: AdminViewModel

    var body: some View {

        List {

            Section {

                ForEach(viewModel.courses) { course in

                    HStack {

                        VStack(alignment: .leading, spacing: 4) {

                            Text(course.name)
                                .fontWeight(.medium)

                            Text(course.professorName)
                                .font(.caption)
                                .foregroundColor(.secondary)

                        }

                        Spacer()

                        Button {
                            
                        } label: {
                            Text("\(course.students.count) Students")
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(.accent.opacity(0.2))
                                .clipShape(Capsule())
                        }
                        
                    }
                    .padding(.vertical, 4)

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
        .sheet(isPresented: $showCreateSheet) {
            Form {

                TextField("Course name", text: $name)

                Button("Create") {
                    viewModel.createCourse(name: name, professor: .init(id: "", name: "", email: "", role: .professor) )
                }
            }
        }
        .onAppear {
            viewModel.fetchUsers()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

#Preview {
    CreateCourseView(viewModel: .constant(.init()))
}
