//
//  DayScheduleView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct DayScheduleView: View {

    let day: Weekday
    let events: [ScheduleItem]

    let startHour: Int
    let endHour: Int
    let hourHeight: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            
            VStack(spacing: 0) {
                
                ForEach(startHour..<endHour, id: \.self) { hour in
                    
                    HStack(alignment: .top) {
                        
                        Text("\(hour):00")
                            .font(.caption)
                            .frame(width: 50, alignment: .leading)
                            .foregroundColor(.textSecondary)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 1)
                        
                    }
                    .frame(height: hourHeight)
                }
            }
            
            ForEach(events) { event in
                
                EventBlock(
                    event: event,
                    startHour: startHour,
                    hourHeight: hourHeight
                )
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    DayScheduleView(day: .monday, events: [], startHour: 7, endHour: 20, hourHeight: 40)
}
