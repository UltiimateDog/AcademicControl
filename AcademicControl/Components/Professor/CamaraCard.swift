//
//  CamaraCard.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CamaraCard: View {

    @State private var courses: [Course] = []
    @State private var selectedCourse: Course? = nil
    @State private var showPicker = false

    private let db = Firestore.firestore()

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
                        Button(course.name) { selectedCourse = course }
                    }
                    Button("Cancel", role: .cancel) {}
                }
            }

            // ── Botón de escaneo ──
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
                // Estado desactivado
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
        .onAppear { loadCourses() }
    }

    // MARK: - Fetch courses where professorId == current user

    private func loadCourses() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        db.collection("courses")
            .whereField("professorId", isEqualTo: uid)
            .getDocuments { snapshot, error in
                guard let docs = snapshot?.documents else { return }
                DispatchQueue.main.async {
                    self.courses = docs.compactMap { doc in
                        let data = doc.data()
                        return Course(
                            id: doc.documentID,
                            name: data["name"] as? String ?? "",
                            professorId: data["professorId"] as? String ?? "",
                            professorName: data["professorName"] as? String ?? "",
                            students: data["students"] as? [String] ?? [],
                            scheduleItems: []
                        )
                    }
                    // Si solo tiene un curso, lo selecciona automáticamente
                    if self.courses.count == 1 {
                        self.selectedCourse = self.courses.first
                    }
                }
            }
    }
}

#Preview {
    NavigationStack {
        CamaraCard()
            .padding()
    }
}
