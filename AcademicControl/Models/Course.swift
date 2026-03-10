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
    
    static let testCourses = [
        Course(id: "1",
               name: "Course 1",
               professorId: "2",
               professorName: "Edwin",
               students: ["Student B", "Student A"]),
        Course(id: "2",
               name: "Course 2",
               professorId: "2",
               professorName: "Edwin",
               students: ["Student B", "Student A"]),
        Course(id: "3",
               name: "Course 3",
               professorId: "2",
               professorName: "Edwin",
               students: ["Student B", "Student A"]),
        Course(id: "4",
               name: "Course 4",
               professorId: "2",
               professorName: "Edwin",
               students: ["Student B", "Student A"]),
        Course(id: "5",
               name: "Course 5",
               professorId: "2",
               professorName: "Edwin",
               students: ["Student B", "Student A"]),
        Course(id: "6",
               name: "Course 6",
               professorId: "2",
               professorName: "Edwin",
               students: ["Student B", "Student A"]),
    ]
    
}
