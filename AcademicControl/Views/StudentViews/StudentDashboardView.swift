//
//  StudentDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct StudentDashboardView: View {

    @State var grades: [Grade] = [
        Grade(id: "1", courseName: "Math", studentName: "You", value: 95),
        Grade(id: "2", courseName: "Physics", studentName: "You", value: 88),
        Grade(id: "3", courseName: "Chemestry", studentName: "You", value: 75),
        Grade(id: "4", courseName: "Arts", studentName: "You", value: 82),
        Grade(id: "5", courseName: "Calculus", studentName: "You", value: 69)
    ]

    @State var schedule: [ScheduleItem] = [
        ScheduleItem(id: "1", courseName: "Math", day: "Monday", time: "10:00"),
        ScheduleItem(id: "2", courseName: "Physics", day: "Wednesday", time: "12:00")
    ]
    
    @State private var scrollOffset: Double = 0

    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(spacing: 20) {
                    
                    QRHeader(offset: scrollOffset)
                    
                    GradesSummaryCard(grades: grades)
                    
                    SchedulePreview(schedule: schedule)
                    
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
            
        }//: Nav
        
    }
}

#Preview {
    StudentDashboardView()
}
