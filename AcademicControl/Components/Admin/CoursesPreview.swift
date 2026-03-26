//
//  CoursesPreview.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct CoursesPreview: View {
    
    @State private var courses: [Course] = Course.testCourses
    
    var groupedCourses: [[Course]] {
        courses.chunked(into: 4)
    }
    
    var body: some View {

        VStack(spacing: 16) {

            NavigationLink {
                CreateCourseView()
            } label: {

                HStack {

                    VStack(alignment: .leading, spacing: 4) {

                        Text("Manage Courses")
                            .font(.headline)

                        Text("Create and Edit")
                            .font(.caption)
                            .foregroundColor(.secondary)

                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemGray6))
                )
            }

            TabView {

                ForEach(groupedCourses.indices, id: \.self) { index in

                    VStack(spacing: 12) {

                        ForEach(groupedCourses[index]) { course in
                            courseRow(course)
                        }

                        Spacer()
                    }
                    .padding(5)
                }


            }
            .tabViewStyle(.page)

        }
        .padding([.bottom, .horizontal])
    }
    
    // MARK: - Course Row
    
    func courseRow(_ course: Course) -> some View {

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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        )
    }
}

#Preview {
    CoursesPreview()
}
