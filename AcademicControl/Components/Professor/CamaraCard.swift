//
//  CamaraCard.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct CamaraCard: View {

    // Recibe los cursos del profesor desde ProfessorDashboardView
    let courses: [Course]

    @State private var selectedCourse: Course? = nil
    @State private var showPicker = false

    var body: some View {
        VStack(spacing: 16) {

            Image(systemName: "camera.viewfinder")
                .font(.system(size: 48))
                .foregroundStyle(.accent)

            Text("Scan Attendance QR")
                .font(.headline)

            Text("Select a course, then scan the QR code shown by the student.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            // ── Course picker ──
            if courses.isEmpty {
                Text("No courses assigned")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Button {
                    showPicker = true
                } label: {
                    HStack {
                        Image(systemName: "books.vertical")
                        Text(selectedCourse?.name ?? "Select course…")
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5))
                    )
                }
                .foregroundStyle(.primary)
                .confirmationDialog("Select a course", isPresented: $showPicker, titleVisibility: .visible) {
                    ForEach(courses) { course in
                        Button(course.name) {
                            selectedCourse = course
                        }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }

            // ── Scan button (only active when a course is selected) ──
            if let course = selectedCourse {
                NavigationLink {
                    QRScannerCameraView(
                        professorCourseId: course.id,
                        professorCourseName: course.name
                    )
                } label: {
                    HStack {
                        Image(systemName: "camera")
                        Text("Start Scanning — \(course.name)")
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.accent)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            } else {
                // Disabled state
                HStack {
                    Image(systemName: "camera")
                    Text("Start Scanning")
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray4))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    NavigationStack {
        CamaraCard(courses: Course.testCourses)
            .padding()
    }
}
