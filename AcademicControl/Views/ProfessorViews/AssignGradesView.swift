//
//  AssignGradesView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct AssignGradesView: View {

    @State var grades: [Grade] = [
        Grade(id: "1", courseName: "Math", studentName: "Student A", value: 90),
        Grade(id: "2", courseName: "Math", studentName: "Student B", value: 85)
    ]

    var body: some View {

        List {

            ForEach($grades) { $grade in

                HStack {

                    Text(grade.studentName)

                    Spacer()

                    TextField(
                        "Grade",
                        value: $grade.value,
                        format: .number
                    )
                    .frame(width: 60)
                    .textFieldStyle(.roundedBorder)

                }
            }

        }
        .navigationTitle("Assign Grades")
        .onAppear {

            // TODO: Fetch enrolled students

        }
    }
}

#Preview {
    AssignGradesView()
}
