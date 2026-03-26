//
//  AddScheduleItemView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 26/03/26.
//

import SwiftUI

struct AddScheduleItemView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedDay: Weekday = .monday
    @State private var startHour = 8
    @State private var startMinute = 0
    @State private var endHour = 9
    @State private var endMinute = 0

    var onAdd: (ScheduleItem) -> Void

    var body: some View {
        NavigationStack {
            Form {

                Picker("Day", selection: $selectedDay) {
                    ForEach(Weekday.allCases) { day in
                        Text(day.name).tag(day)
                    }
                }

                Stepper("Start Hour: \(startHour)", value: $startHour, in: 0...23)
                Stepper("Start Minute: \(startMinute)", value: $startMinute, in: 0...59, step: 5)

                Stepper("End Hour: \(endHour)", value: $endHour, in: 0...23)
                Stepper("End Minute: \(endMinute)", value: $endMinute, in: 0...59, step: 5)

                Button("Add") {

                    let newItem = ScheduleItem(
                        courseName: "",
                        weekday: selectedDay,
                        startHour: startHour,
                        startMinute: startMinute,
                        endHour: endHour,
                        endMinute: endMinute
                    )

                    onAdd(newItem)
                    dismiss()
                }
            }
            .navigationTitle("New Schedule")
        }
    }
}

#Preview {
    AddScheduleItemView() { _ in 
        
    }
}
