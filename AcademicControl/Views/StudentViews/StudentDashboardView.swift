//
//  StudentDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct StudentDashboardView: View {

    @Environment(Session.self) private var session

    @State var grades: [Grade] = [
        Grade(id: "1", courseName: "Math", studentName: "You", value: 95),
        Grade(id: "2", courseName: "Physics", studentName: "You", value: 88),
        Grade(id: "3", courseName: "Chemistry", studentName: "You", value: 75),
        Grade(id: "4", courseName: "Arts", studentName: "You", value: 82),
        Grade(id: "5", courseName: "Calculus", studentName: "You", value: 69)
    ]

    @State var schedule: [ScheduleItem] = ScheduleItem.testSchedule
    @State private var scrollOffset: Double = 0

    // Materia activa ahora mismo (la que toca según horario actual)
    private var currentCourse: ScheduleItem? {
        let now = Calendar.current.dateComponents([.weekday, .hour, .minute], from: Date())
        // Calendar: domingo=1, lunes=2 … ajustamos al enum Weekday
        let weekdayRaw = ((now.weekday ?? 1) - 1) % 7  // 0=dom, 1=lun…
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

                    // ── QR Header con datos reales ──
                    if let user = session.currentUser {
                        QRHeader(
                            offset: scrollOffset,
                            studentId: user.id,
                            studentName: user.name,
                            courseId: currentCourse?.id.uuidString ?? "no-class",
                            courseName: currentCourse?.courseName ?? "No class right now"
                        )
                    }

                    GradesSummaryCard(grades: grades)

                    SchedulePreview(schedule: schedule)

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
        }
    }
}

#Preview {
    @Previewable @State var session = Session()
    StudentDashboardView()
        .environment(session)
}
