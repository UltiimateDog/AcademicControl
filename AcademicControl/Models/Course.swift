//
//  Course.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import Foundation

struct Course: Identifiable {

    let id: String
    var name: String
    var professorId: String
    var professorName: String
    var students: [String]
    var scheduleItems: [ScheduleItem]
    
    static let testCourses = [
        Course(id: "1",
               name: "Course 1",
               professorId: "2",
               professorName: "Edwin",
               students: ["Student B", "Student A"],
              scheduleItems: [])
    ]
    
}
