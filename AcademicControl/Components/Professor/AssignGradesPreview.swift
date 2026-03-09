//
//  AssignGradesView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct AssignGradesPreview: View {

    @State var grades: [Grade] = Grade.testGrades

    var groupedGrades: [[Grade]] {
        grades.chunked(into: 4)
    }

    var body: some View {
        
        VStack(spacing: 20) {
            
            NavigationLink {
                AssignGradesView(grades: $grades)
            } label: {
                HStack {
                    Text("Assign Grades")
                        .font(.headline)
                        .foregroundColor(.textPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.textSecondary)
                }
            }
            
            TabView {

                ForEach(groupedGrades.indices, id: \.self) { index in

                    VStack(spacing: 12) {

                        ForEach(groupedGrades[index]) { grade in
                            gradeRow(grade)
                        }

                        Spacer()

                    }
                }

            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
    }

    // MARK: Row

    func gradeRow(_ grade: Grade) -> some View {

        HStack {

            VStack(alignment: .leading, spacing: 2) {

                Text(grade.studentName)
                    .font(.body)
                    .fontWeight(.medium)

                Text(grade.courseName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if let binding = binding(for: grade) {

                TextField("0",
                          value: binding.value,
                          format: .number)
                    .keyboardType(.numberPad)
                    .frame(width: 55)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.primaryC.opacity(0.2))
                    )
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        )
    }

    // MARK: Binding helper

    private func binding(for grade: Grade) -> Binding<Grade>? {

        guard let index = grades.firstIndex(where: { $0.id == grade.id }) else {
            return nil
        }

        return $grades[index]
    }
}

extension Array {

    func chunked(into size: Int) -> [[Element]] {

        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

#Preview {
    AssignGradesPreview()
}
