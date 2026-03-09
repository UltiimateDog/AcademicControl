//
//  Grade.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import Foundation

struct Grade: Identifiable {

    let id: String
    var courseName: String
    var studentName: String
    var value: Int
    
    static let testGrades = [
        Grade(id: "1", courseName: "Math", studentName: "Student A", value: 90),
        Grade(id: "2", courseName: "Math", studentName: "Student B", value: 85),
        Grade(id: "3", courseName: "Math", studentName: "Student C", value: 70),
        Grade(id: "4", courseName: "Math", studentName: "Student D", value: 95),
        Grade(id: "5", courseName: "Math", studentName: "Student E", value: 88),
        Grade(id: "6", courseName: "Math", studentName: "Student F", value: 77)
    ]
}
