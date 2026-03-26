//
//  RootView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct RootView: View {

    @Environment(Session.self) private var session

    var body: some View {

        if let user = session.currentUser {

            switch user.role {

            case .admin:
                AdminDashboardView()
                    .transition(.move(edge: .trailing))


            case .professor:
                ProfessorDashboardView()
                    .transition(.move(edge: .trailing))


            case .student:
                StudentDashboardView()
                    .transition(.move(edge: .trailing))

            }

        } else {
            
            LoginView()
            
        }
        
    }
}

#Preview {
    @Previewable @State var session = Session()
    
    RootView()
        .environment(session)
}
