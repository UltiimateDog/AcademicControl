//
//  RootView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct RootView: View {

    @Environment(SessionStore.self) private var session

    var body: some View {

        if let user = session.currentUser {

            switch user.role {

            case .admin:
                AdminDashboardView()

            case .professor:
                ProfessorDashboardView()

            case .student:
                StudentDashboardView()
            }

        } else {
            
            LoginView()
            
        }
        
    }
}

#Preview {
    @Previewable @State var session = SessionStore()
    
    RootView()
        .environment(session)
}
