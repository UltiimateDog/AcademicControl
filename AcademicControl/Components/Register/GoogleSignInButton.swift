//
//  GoogleSignInButton.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct GoogleSignInButton: View {

    var action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack(spacing: 12) {

                Image(.googleSvg)   // Add logo to Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)

                Text("Sign in with Google")
                    .fontWeight(.semibold)

                Spacer()

            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .foregroundColor(.black)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3))
            )
            .cornerRadius(10)
        }
    }
}

#Preview {
    GoogleSignInButton() {
        
    }
}
