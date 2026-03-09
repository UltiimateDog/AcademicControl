//
//  ManageUsersView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct ManageUsersView: View {

    @State var users: [User] = [
        User(id: "1", name: "Alice", email: "alice@mail.com", role: .student),
        User(id: "2", name: "Bob", email: "bob@mail.com", role: .professor)
    ]

    var body: some View {

        List(users) { user in

            HStack {

                VStack(alignment: .leading) {

                    Text(user.name)

                    Text(user.email)
                        .font(.caption)

                }

                Spacer()

                Text(user.role.rawValue)
            }
        }
        .navigationTitle("Users")
        .onAppear {

            // TODO: Fetch users from backend

        }
    }
    
}

#Preview {
    ManageUsersView()
}
