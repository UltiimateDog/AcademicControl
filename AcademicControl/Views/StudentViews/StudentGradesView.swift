//
//  StudentGradesView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct StudentGradesView: View {

    @State var grades: [Grade] = [
        Grade(id: "1", courseName: "Math", studentName: "You", value: 95),
        Grade(id: "2", courseName: "Physics", studentName: "You", value: 88)
    ]

    var body: some View {

        List(grades) { grade in

            HStack {

                Text(grade.courseName)

                Spacer()

                Text("\(grade.value)")
            }

        }
        .navigationTitle("My Grades")
        .onAppear {

            // TODO: Fetch grades from backend

        }
    }
}

#Preview {
    StudentGradesView()
}
