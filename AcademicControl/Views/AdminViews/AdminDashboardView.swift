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
            
            ScrollView {
                ManageUsersPreview()
                    .frame(height: 460)
                
                NavigationLink("Create Course") {
                    CreateCourseView()
                }
            }
            .scrollIndicators(.hidden)
            .background(Color.background)
            .navigationTitle("Admin")
        }
    }
    
}

#Preview {
    AdminDashboardView()
}
