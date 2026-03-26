//
//  AdminDashboardView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct AdminDashboardView: View {
    
    @State private var viewModel = AdminViewModel()

    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                VStack (spacing: 0) {
                    
                    ManageUsersPreview(viewModel: $viewModel)
                        .frame(height: 460)
                    
                    CoursesPreview(viewModel: $viewModel)
                        .frame(height: 460)
                    
                    LogoutButton()
                        .padding()
                }
                
            }
            .scrollIndicators(.hidden)
            .background(Color.background)
            .navigationTitle("Admin")
        }
    }
    
}

#Preview {
    @Previewable @State var session = Session()
    
    AdminDashboardView()
        .environment(session)
}
