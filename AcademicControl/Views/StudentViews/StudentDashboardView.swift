//
//  StudentDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI
import FirebaseAuth

struct StudentDashboardView: View {

    @Environment(Session.self) private var session

    @State private var grades: [Grade] = []
    @State private var schedule: [ScheduleItem] = []
    @State private var isLoading = true
    @State private var scrollOffset: Double = 0
    private let viewModel = CourseViewModel()

    // Materia que toca en este momento según el horario cargado
    private var currentCourse: ScheduleItem? {
        let cal = Calendar.current
        let now = cal.dateComponents([.weekday, .hour, .minute], from: Date())
        // Calendar: dom=1, lun=2 … Weekday enum: lun=1, mar=2 …
        let weekdayRaw = ((now.weekday ?? 2) - 1) == 0 ? 7 : (now.weekday ?? 2) - 1
        let currentMinutes = (now.hour ?? 0) * 60 + (now.minute ?? 0)

        return schedule.first { item in
            item.weekday.rawValue == weekdayRaw &&
            currentMinutes >= item.startTotalMinutes &&
            currentMinutes < item.endTotalMinutes
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // ── QR con datos reales del alumno ──
                    if let user = session.currentUser {
                        QRHeader(
                            offset: scrollOffset,
                            studentId: user.id,
                            studentName: user.name,
                            courseId: currentCourse?.id.uuidString ?? "no-class",
                            courseName: currentCourse?.courseName ?? "No class right now"
                        )
                    }

                    if isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else {
                        GradesSummaryCard(grades: grades)
                        SchedulePreview(schedule: schedule)
                    }

                    LogoutButton()
                        .padding()
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .background(Color.background)
            .navigationTitle("Dashboard")
            .onScrollGeometryChange(for: Double.self) { geo in
                geo.contentOffset.y + geo.contentInsets.top
            } action: { _, newValue in
                scrollOffset = newValue
            }
            .onAppear { loadData() }
        }
    }

    private func loadData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        let group = DispatchGroup()

        group.enter()
        viewModel.fetchScheduleForStudent(uid: uid) { items in
            self.schedule = items
            group.leave()
        }

        group.enter()
        viewModel.fetchGradesForStudent(uid: uid) { fetchedGrades in
            self.grades = fetchedGrades
            group.leave()
        }

        group.notify(queue: .main) { self.isLoading = false }
    }
}

#Preview {
    @Previewable @State var session = Session()
    StudentDashboardView().environment(session)
}
