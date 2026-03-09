//
//  ScheduleView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct ScheduleView: View {

    @State var schedule: [ScheduleItem] = [
        ScheduleItem(id: "1", courseName: "Math", day: "Monday", time: "10:00"),
        ScheduleItem(id: "2", courseName: "Physics", day: "Wednesday", time: "12:00")
    ]

    var body: some View {

        List(schedule) { item in

            VStack(alignment: .leading) {

                Text(item.courseName)
                    .font(.headline)

                Text("\(item.day) - \(item.time)")
                    .font(.caption)
            }
        }
        .navigationTitle("Schedule")
        .onAppear {

            // TODO: Fetch schedule from backend

        }
    }
}

#Preview {
    ScheduleView()
}
