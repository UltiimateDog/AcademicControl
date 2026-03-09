//
//  SchedulePreview.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct SchedulePreview: View {

    var schedule: [ScheduleItem]

    private let startHour = 7
    private let endHour = 20
    private let hourHeight: CGFloat = 70

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {
            
            HStack {
                
                Text("Schedule")
                    .font(.headline)
                    .foregroundColor(.textPrimary)
                
            }
            
            TabView {
                
                ForEach(Weekday.allCases) { day in
                    DayScheduleView(
                        day: day,
                        events: schedule.filter { $0.weekday == day },
                        startHour: startHour,
                        endHour: endHour,
                        hourHeight: hourHeight
                    )
                }
                
            }
            .frame(height: hourHeight * CGFloat(endHour - startHour))
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

#Preview {
    SchedulePreview(schedule: [])
}
