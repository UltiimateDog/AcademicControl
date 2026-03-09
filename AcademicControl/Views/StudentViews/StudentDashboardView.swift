//
//  StudentDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct StudentDashboardView: View {

    var body: some View {

        NavigationStack {

            List {

                NavigationLink("My QR Code") {
                    QRCodeView()
                }

                NavigationLink("My Grades") {
                    StudentGradesView()
                }

                NavigationLink("My Schedule") {
                    ScheduleView()
                }

            }
            .navigationTitle("Student")
        }
    }
}

#Preview {
    StudentDashboardView()
}
