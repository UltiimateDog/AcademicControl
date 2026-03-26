//
//  ProfessorDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct ProfessorDashboardView: View {
    
    @State var schedule: [ScheduleItem] = ScheduleItem.testSchedule

    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    CamaraCard()
                    
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
        }
    }
    
}

#Preview {
    ProfessorDashboardView()
}
