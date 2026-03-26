//
//  LogoutButton.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 26/03/26.
//

import SwiftUI

struct LogoutButton: View {
    @Environment(Session.self) private var session

    var body: some View {
        Button(role: .destructive) {
            session.logout()
        } label: {
            HStack {
                Image(systemName: "arrow.right.square")
                Text("Log Out")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.primaryC)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .cornerRadius(10)
        }
    }
}

#Preview {
    LogoutButton()
}
