//
//  ManageUsersPreview.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct ManageUsersPreview: View {
    
    @Bindable var viewModel: AdminViewModel

    var groupedUsers: [[User]] {
        viewModel.users.chunked(into: 4)
    }

    var body: some View {

        VStack(spacing: 16) {

            NavigationLink {
                ManageUsersView(viewModel: viewModel)
            } label: {

                HStack {

                    VStack(alignment: .leading, spacing: 4) {

                        Text("Manage Users")
                            .font(.headline)

                        Text("Students and professors")
                            .font(.caption)
                            .foregroundColor(.secondary)

                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemGray6))
                )
            }
            
            
            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                TabView {
                    
                    ForEach(groupedUsers.indices, id: \.self) { index in
                        
                        VStack(spacing: 12) {
                            
                            ForEach(groupedUsers[index]) { user in
                                userRow(user)
                            }
                            
                            Spacer()
                        }
                        .padding(5)
                    }
                    
                }
                .tabViewStyle(.page)
            }

        }
        .padding([.top, .horizontal])
        .onAppear {
            viewModel.fetchUsers()
        }
    }

    func userRow(_ user: User) -> some View {

        HStack {

            VStack(alignment: .leading, spacing: 4) {

                Text(user.name)
                    .fontWeight(.medium)

                Text(user.email)
                    .font(.caption)
                    .foregroundColor(.secondary)

            }

            Spacer()

            roleBadge(user.role)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        )
    }

    func roleBadge(_ role: User.Role) -> some View {

        Text(role.rawValue.capitalized)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(.accent.opacity(0.2))
            .clipShape(Capsule())
    }
}

#Preview {
    ManageUsersPreview(viewModel: .init())
}
