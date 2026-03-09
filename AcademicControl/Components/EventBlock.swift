//
//  EventBlock.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct EventBlock: View {

    let event: ScheduleItem
    let startHour: Int
    let hourHeight: CGFloat

    var startOffset: CGFloat {
        let totalMinutes =
            (event.startHour - startHour) * 60 + event.startMinute
        return CGFloat(totalMinutes) / 60 * hourHeight
    }

    var height: CGFloat {
        let duration =
            (event.endHour * 60 + event.endMinute) -
            (event.startHour * 60 + event.startMinute)

        return CGFloat(duration) / 60 * hourHeight
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 4) {

            Text(event.courseName)
                .font(.caption)
                .bold()

            Text("\(event.startHour):\(String(format: "%02d", event.startMinute)) - \(event.endHour):\(String(format: "%02d", event.endMinute))")
                .font(.caption2)

        }
        .padding(6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: height)
        .background(.primaryC.opacity(0.2))
        .cornerRadius(8)
        .offset(x: 60, y: startOffset + hourHeight / 2 - 6)
    }
}

#Preview {
    EventBlock(
        event: ScheduleItem(
            courseName: "Mathematics",
            weekday: .monday,
            startHour: 8,
            startMinute: 0,
            endHour: 10,
            endMinute: 0
        ),
        startHour: 7,
        hourHeight: 1.5)
}
