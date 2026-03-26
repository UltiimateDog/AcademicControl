//
//  ProfessorDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI
import FirebaseAuth

struct ProfessorDashboardView: View {

    @State private var schedule: [ScheduleItem] = []
    @State private var isLoading = true
    private let viewModel = CourseViewModel()

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 20) {

                    CamaraCard()

                    AssignGradesPreview()
                        .frame(height: 370)

                    if isLoading {
                        ProgressView("Loading schedule...")
                            .padding()
                    } else {
                        SchedulePreview(schedule: schedule)
                    }

                }
                .padding()

            }
            .scrollIndicators(.hidden)
            .background(Color.background)
            .navigationTitle("Professor")
            .onAppear {
                loadSchedule()
            }
        }
    }

    private func loadSchedule() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        viewModel.fetchScheduleForProfessor(uid: uid) { items in
            self.schedule = items
            self.isLoading = false
        }
    }
}

#Preview {
    ProfessorDashboardView()
}
