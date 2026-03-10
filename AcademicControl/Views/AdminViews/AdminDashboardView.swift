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
                VStack (spacing: 0) {
                    
                    ManageUsersPreview()
                        .frame(height: 460)
                    
                    CoursesPreview()
                        .frame(height: 460)
                    
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
