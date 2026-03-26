//
//  AddScheduleItemView.swift
//  AcademicControl
//
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

                Section("Day") {
                    Picker("Weekday", selection: $selectedDay) {
                        ForEach(Weekday.allCases) { day in
                            Text(day.name).tag(day)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Start time") {
                    Stepper("Hour: \(startHour)", value: $startHour, in: 0...23)
                    Stepper("Minute: \(String(format: "%02d", startMinute))",
                            value: $startMinute, in: 0...59, step: 5)
                }

                Section("End time") {
                    Stepper("Hour: \(endHour)", value: $endHour, in: 0...23)
                    Stepper("Minute: \(String(format: "%02d", endMinute))",
                            value: $endMinute, in: 0...59, step: 5)
                }
            }
            .navigationTitle("Add Time Slot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let item = ScheduleItem(
                            courseName: "",
                            weekday: selectedDay,
                            startHour: startHour,
                            startMinute: startMinute,
                            endHour: endHour,
                            endMinute: endMinute
                        )
                        onAdd(item)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddScheduleItemView { _ in }
}
