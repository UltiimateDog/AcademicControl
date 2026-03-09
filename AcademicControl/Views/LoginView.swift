//
//  LoginView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct LoginView: View {

    @State private var email = ""
    @State private var password = ""
    
    @State private var isLogin = true

    var body: some View {
        
        
        ZStack {
            
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                Spacer()
                
                // Logo / Title
                VStack(spacing: 8) {
                    
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.primaryC)
                    
                    Text("Academic Control")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.textPrimary)
                    
                    Text("Manage your academic life")
                        .font(.subheadline)
                        .foregroundColor(.textSecondary)
                }
                
                if isLogin {
                    
                    LoginCard(isLogin: $isLogin)
                        .transition(.move(edge: .leading))
                    
                } else {
                    
                    RegisterCard(isLogin: $isLogin)
                        .transition(.move(edge: .trailing))
                    
                }
                
                Spacer()
            }
        }
    }
    
}

#Preview {
    LoginView()
}
