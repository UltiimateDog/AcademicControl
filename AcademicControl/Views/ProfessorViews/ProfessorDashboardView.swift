//
//  ProfessorDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct ProfessorDashboardView: View {

    @Environment(Session.self) private var session

    @State private var viewModel = ProfessorViewModel()
    @State var schedule: [ScheduleItem] = ScheduleItem.testSchedule

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // ── Loading / error ──
                    if viewModel.isLoading {
                        ProgressView("Loading courses…")
                            .padding()
                    } else if let error = viewModel.errorMessage {
                        Text("Error: \(error)")
                            .foregroundStyle(.red)
                            .font(.caption)
                            .padding()
                    }

                    // ── Cámara card con cursos reales ──
                    CamaraCard(courses: viewModel.courses)

                    AssignGradesPreview()
                        .frame(height: 370)

                    SchedulePreview(schedule: schedule)

                    LogoutButton()
                        .padding()
                }
                .padding()
            }
            .scrollIndicators(.hidden)
            .background(Color.background)
            .navigationTitle("Professor")
            .onAppear {
                if let uid = session.currentUser?.id {
                    viewModel.fetchCourses(professorId: uid)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var session = Session()
    ProfessorDashboardView()
        .environment(session)
}
