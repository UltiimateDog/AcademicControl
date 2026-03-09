//
//  LoginCard.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct LoginCard: View {
    
    @Environment(SessionStore.self) private var session

    
    @State private var email = ""
    @State private var password = ""
    
    @Binding var isLogin: Bool
    
    
    var body: some View {
        VStack(spacing: 20) {

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button {
                withAnimation {
                    session.login(email: email, password: password)
                }
            } label: {

                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.primaryC)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Button {
                withAnimation {
                    isLogin = false
                }
            } label: {

                Text("Create an account")
                    .foregroundColor(.primaryC)
            }
            
            AuthDivider()

            AppleSignInButton {

                // TODO: Firebase Apple Sign-In
                print("Apple login tapped")

            }

            GoogleSignInButton {

                // TODO: Firebase Google Sign-In
                print("Google login tapped")

            }

        }
        .padding(25)
        .background(.card)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 24)
    }
}

#Preview {
    LoginCard(isLogin: .constant(true))
}
