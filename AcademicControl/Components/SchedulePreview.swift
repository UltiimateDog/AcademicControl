//
//  SchedulePreview.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct SchedulePreview: View {

    var schedule: [ScheduleItem]

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            NavigationLink {

                ScheduleView()

            } label: {

                HStack {

                    Text("Schedule")
                        .font(.headline)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.textSecondary)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 16) {

                    ForEach(schedule) { item in

                        VStack(alignment: .leading, spacing: 6) {

                            Text(item.day)
                                .font(.caption)
                                .foregroundColor(.textSecondary)

                            Text(item.courseName)
                                .font(.headline)
                                .foregroundColor(.textPrimary)

                            Text(item.time)
                                .font(.caption)
                                .foregroundColor(.textSecondary)

                        }
                        .padding()
                        .frame(width: 140)
                        .background(.card)
                        .cornerRadius(14)
                        .shadow(radius: 2)
                    }
                }
            }

        }
    }
}

#Preview {
    SchedulePreview(schedule: [])
}
