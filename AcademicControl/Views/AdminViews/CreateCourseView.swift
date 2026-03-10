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
    
    @Binding var courses: [Course]

    var body: some View {

        List {

            Section {

                ForEach($courses) { $course in

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
                Text("\(courses.count) Courses")
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

                    // TODO: Send course creation to backend

                }

            }
        }
        .onAppear {

            // TODO: Fetch users from backend

        }
    }
}

#Preview {
    CreateCourseView(courses: .constant([]))
}
