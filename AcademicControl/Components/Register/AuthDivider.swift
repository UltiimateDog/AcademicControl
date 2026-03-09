//
//  AuthDivider.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct AuthDivider: View {

    var body: some View {

        HStack {

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))

            Text("OR")
                .font(.caption)
                .foregroundColor(.gray)

            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.3))

        }
        .padding(.vertical, 10)
    }
}

#Preview {
    AuthDivider()
}
