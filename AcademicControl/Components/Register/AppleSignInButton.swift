//
//  AppleSignInButton.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct AppleSignInButton: View {

    var action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack {

                Image(systemName: "apple.logo")
                    .font(.system(size: 18, weight: .medium))

                Text("Sign in with Apple")
                    .fontWeight(.semibold)

                Spacer()

            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black)
            .cornerRadius(10)
        }
    }
}

#Preview {
    AppleSignInButton() {
        
    }
}
