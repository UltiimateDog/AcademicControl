//
//  GradesSummaryCard.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct GradesSummaryCard: View {

    var grades: [Grade]

    private var averageGrade: Double {
        guard !grades.isEmpty else { return 0 }
        return grades.map { Double($0.value) }.reduce(0, +) / Double(grades.count)
    }

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            // Header
            HStack {

                VStack(alignment: .leading, spacing: 4) {
                    Text("Grades")
                        .font(.headline)
                        .foregroundStyle(.textPrimary)

                    Text("\(grades.count) courses")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 6) {
                    
                    Text(String(format: "%.1f", averageGrade))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(gradeColor(averageGrade))
                    
                    Image(systemName: gradeIcon(averageGrade))
                        .foregroundStyle(gradeColor(averageGrade))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .glassEffect(.regular.tint(gradeColor(averageGrade).opacity(0.2)).interactive())

            }

            Divider()

            // Grades list
            VStack(spacing: 12) {

                ForEach(grades, id: \.id) { grade in

                    HStack {

                        Text("\(grade.courseName)")
                            .font(.subheadline)
                            .foregroundColor(.textPrimary)

                        Spacer()

                        HStack(spacing: 6) {
                            
                            Text("\(grade.value)")
                                .fontWeight(.semibold)
                                .foregroundStyle(gradeColor(Double(grade.value)))

                            Image(systemName: gradeIcon(Double(grade.value)))
                                .foregroundStyle(gradeColor(Double(grade.value)))
                            
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(gradeColor(Double(grade.value)).opacity(0.20))
                        .clipShape(Capsule())
                    }
                }//: Foreach
            }
        }
        .padding(18)
        .background(.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    }

    // MARK: - Helpers

    func gradeColor(_ grade: Double) -> Color {
        if grade >= 90 { return .primaryC }
        if grade >= 80 { return .secondaryC }
        if grade >= 70 { return .orange }
        return .red
    }

    func gradeIcon(_ grade: Double) -> String {
        if grade >= 90 { return "star.fill" }
        if grade >= 80 { return "checkmark.circle.fill" }
        if grade >= 70 { return "exclamationmark.circle.fill" }
        return "xmark.circle.fill"
    }
}

#Preview {
    GradesSummaryCard(grades: [] )
}
