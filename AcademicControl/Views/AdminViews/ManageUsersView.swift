//
//  ManageUsersView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct ManageUsersView: View {

    @Binding var users: [User]

    var body: some View {

        List {

            Section {

                ForEach($users) { $user in

                    HStack {

                        VStack(alignment: .leading, spacing: 4) {

                            Text(user.name)
                                .fontWeight(.medium)

                            Text(user.email)
                                .font(.caption)
                                .foregroundColor(.secondary)

                        }

                        Spacer()

                        roleSelector(user: $user)

                    }
                    .padding(.vertical, 4)

                }

            } header: {
                Text("\(users.count) Users")
            }

        }
        .listStyle(.insetGrouped)
        .navigationTitle("Users")
        .onAppear {

            // TODO: Fetch users from backend

        }
    }

    // MARK: Role Selector

    func roleSelector(user: Binding<User>) -> some View {

        Menu {

            Button("Student") {
                user.wrappedValue.role = .student
                // TODO: Update role in backend
            }

            Button("Professor") {
                user.wrappedValue.role = .professor
                // TODO: Update role in backend
            }

        } label: {

            HStack(spacing: 4) {

                Text(user.wrappedValue.role.rawValue.capitalized)
                    .font(.caption)

                Image(systemName: "chevron.down")
                    .font(.caption2)

            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.systemGray5))
            .clipShape(Capsule())

        }
    }
}

#Preview {
    ManageUsersView(users: .constant([]))
}
