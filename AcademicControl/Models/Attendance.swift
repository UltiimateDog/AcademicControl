//
//  Attendance.swift
//  AcademicControl
//
//  Created by Rafael on 26/03/26.
//
 
import Foundation
 
struct Attendance: Identifiable {
    let id: String
    let studentId: String
    let studentName: String
    let courseId: String
    let courseName: String
    let timestamp: Date
 
    // El payload que va dentro del QR
    struct QRPayload: Codable {
        let studentId: String
        let studentName: String
        let courseId: String
        let courseName: String
        let expiresAt: TimeInterval   // Unix timestamp — el QR expira en 60 seg
    }
}
