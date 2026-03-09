//
//  ProfessorDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct ProfessorDashboardView: View {

    var body: some View {

        NavigationStack {

            List {

                NavigationLink("Take Attendance") {
                    QRScannerView()
                }

                NavigationLink("Assign Grades") {
                    AssignGradesView()
                }

                NavigationLink("My Schedule") {
                    
                }

            }
            .navigationTitle("Professor")
        }
    }
    
}

#Preview {
    ProfessorDashboardView()
}
