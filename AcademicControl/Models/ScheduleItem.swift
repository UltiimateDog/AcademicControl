//
//  ScheduleItem.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import Foundation

enum Weekday: Int, CaseIterable, Identifiable {
    case monday = 1
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var id: Int { rawValue }

    var name: String {
        switch self {
        case .monday: "Monday"
        case .tuesday: "Tuesday"
        case .wednesday: "Wednesday"
        case .thursday: "Thursday"
        case .friday: "Friday"
        case .saturday: "Saturday"
        case .sunday: "Sunday"
        }
    }
}

struct ScheduleItem: Identifiable {

    let id: UUID = UUID()

    var courseName: String
    var weekday: Weekday

    var startHour: Int
    var startMinute: Int

    var endHour: Int
    var endMinute: Int
    
    static let testSchedule: [ScheduleItem] = [
        
        // Monday
        ScheduleItem(
            courseName: "Mathematics",
            weekday: .monday,
            startHour: 8,
            startMinute: 0,
            endHour: 9,
            endMinute: 30
        ),

        ScheduleItem(
            courseName: "Physics",
            weekday: .monday,
            startHour: 10,
            startMinute: 0,
            endHour: 11,
            endMinute: 30
        ),

        ScheduleItem(
            courseName: "Programming",
            weekday: .monday,
            startHour: 14,
            startMinute: 0,
            endHour: 16,
            endMinute: 0
        ),


        // Tuesday
        ScheduleItem(
            courseName: "English",
            weekday: .tuesday,
            startHour: 9,
            startMinute: 0,
            endHour: 10,
            endMinute: 0
        ),

        ScheduleItem(
            courseName: "Data Structures",
            weekday: .tuesday,
            startHour: 11,
            startMinute: 0,
            endHour: 13,
            endMinute: 0
        ),


        // Wednesday
        ScheduleItem(
            courseName: "Chemistry",
            weekday: .wednesday,
            startHour: 8,
            startMinute: 30,
            endHour: 10,
            endMinute: 0
        ),

        ScheduleItem(
            courseName: "Algorithms",
            weekday: .wednesday,
            startHour: 12,
            startMinute: 0,
            endHour: 13,
            endMinute: 30
        ),


        // Thursday
        ScheduleItem(
            courseName: "Databases",
            weekday: .thursday,
            startHour: 10,
            startMinute: 0,
            endHour: 12,
            endMinute: 0
        ),

        ScheduleItem(
            courseName: "Operating Systems",
            weekday: .thursday,
            startHour: 15,
            startMinute: 0,
            endHour: 17,
            endMinute: 0
        ),


        // Friday
        ScheduleItem(
            courseName: "Artificial Intelligence",
            weekday: .friday,
            startHour: 9,
            startMinute: 0,
            endHour: 11,
            endMinute: 0
        ),

        ScheduleItem(
            courseName: "Computer Networks",
            weekday: .friday,
            startHour: 12,
            startMinute: 30,
            endHour: 14,
            endMinute: 0
        )
    ]
}

extension ScheduleItem {

    var startTotalMinutes: Int {
        startHour * 60 + startMinute
    }

    var endTotalMinutes: Int {
        endHour * 60 + endMinute
    }

    var durationMinutes: Int {
        endTotalMinutes - startTotalMinutes
    }

    var timeString: String {
        String(format: "%02d:%02d - %02d:%02d",
               startHour, startMinute,
               endHour, endMinute)
    }
}
