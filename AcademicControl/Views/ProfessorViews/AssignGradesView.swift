//
//  AssignGradesFullView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct AssignGradesView: View {

    @Binding var grades: [Grade]

    var body: some View {

        List {

            Section {

                ForEach($grades) { $grade in
                    gradeRow(grade: $grade)
                }

            } header: {
                Text("\(grades.count) Students")
            }

        }
        .listStyle(.insetGrouped)
        .navigationTitle("All Students")
    }

    // MARK: Row

    func gradeRow(grade: Binding<Grade>) -> some View {

        HStack(spacing: 12) {

            // Student info
            VStack(alignment: .leading, spacing: 4) {

                Text(grade.wrappedValue.studentName)
                    .font(.body)
                    .fontWeight(.medium)

                Text(grade.wrappedValue.courseName)
                    .font(.caption)
                    .foregroundColor(.secondary)

            }

            Spacer()

            // Grade input
            TextField(
                "0",
                value: grade.value,
                format: .number
            )
            .keyboardType(.numberPad)
            .frame(width: 60)
            .padding(6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.primaryC.opacity(0.2))
            )
            .multilineTextAlignment(.center)

        }
        .padding(.vertical, 6)
    }
}

#Preview {
    NavigationStack {
        AssignGradesView(grades: .constant(Grade.testGrades))
    }
}
