//
//  AdminDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct AdminDashboardView: View {

    var body: some View {

        NavigationStack {

            List {

                NavigationLink("Manage Users") {
                    ManageUsersView()
                }

                NavigationLink("Create Course") {
                    CreateCourseView()
                }

            }
            .navigationTitle("Admin")
        }
    }
    
}

#Preview {
    AdminDashboardView()
}
