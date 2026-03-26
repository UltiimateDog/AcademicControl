//
//  ManageUsersView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI
import FirebaseAuth

struct ManageUsersView: View {

    @State private var viewModel = AdminViewModel()

    var body: some View {

        List {

            Section {

                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    ForEach(viewModel.users) { user in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .fontWeight(.medium)
                                Text(user.email)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            roleSelector(user: user)
                        }
                        .padding(.vertical, 4)
                    }
                }

            } header: {
                Text("\(viewModel.users.count) Users")
            }

        }
        .listStyle(.insetGrouped)
        .navigationTitle("Users")
        .onAppear {
            print(Auth.auth().currentUser?.uid ?? "No user")
            
            viewModel.fetchUsers()
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }

    // MARK: - Role Selector

    func roleSelector(user: User) -> some View {

        Menu {

            Button("Student") {
                viewModel.updateRole(for: user, to: .student)
            }

            Button("Professor") {
                viewModel.updateRole(for: user, to: .professor)
            }

            Button("Admin") {
                viewModel.updateRole(for: user, to: .admin)
            }

        } label: {

            HStack(spacing: 4) {
                Text(user.role.rawValue.capitalized)
                    .font(.caption)
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(roleColor(user.role).opacity(0.2))
            .clipShape(Capsule())
        }
    }

    // MARK: - Role color

    func roleColor(_ role: User.Role) -> Color {
        switch role {
        case .admin:    return .red
        case .professor: return .blue
        case .student:  return .accent
        }
    }
}

#Preview {
    NavigationStack {
        ManageUsersView()
    }
}
