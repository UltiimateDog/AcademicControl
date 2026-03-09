//
//  RegisterView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct RegisterCard: View {
    
    @Environment(SessionStore.self) private var session
    
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    
    @Binding var isLogin: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            
            VStack(spacing: 16) {
                
                TextField("Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
                
            }
            
            Button {
                
                withAnimation {
                    session.login(email: email, password: password)
                }
                // TODO: Firebase register
                
            } label: {
                
                Text("Register")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.primaryC)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button("Back to Login") {
                withAnimation {
                    isLogin = true
                }
            }
            .foregroundColor(.secondaryC)
                        
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
        .padding(30)
        .background(.card)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 24)
        
    }
}

#Preview {
    RegisterCard(isLogin: .constant(false))
}
