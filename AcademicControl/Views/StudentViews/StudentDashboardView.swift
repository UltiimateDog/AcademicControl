//
//  StudentDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI
import FirebaseAuth

struct StudentDashboardView: View {

    @State private var grades: [Grade] = []
    @State private var schedule: [ScheduleItem] = []
    @State private var isLoading = true
    @State private var scrollOffset: Double = 0
    private let viewModel = CourseViewModel()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    QRHeader(offset: scrollOffset)

                    if isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else {
                        GradesSummaryCard(grades: grades)

                        SchedulePreview(schedule: schedule)
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
            .onAppear {
                loadData()
            }
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

        group.notify(queue: .main) {
            self.isLoading = false
        }
    }
}

#Preview {
    @Previewable @State var session = Session()
    
    StudentDashboardView()
        .environment(session)
}
