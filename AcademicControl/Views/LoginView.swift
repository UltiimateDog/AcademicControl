//
//  LoginView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

import SwiftUI

struct LoginView: View {

    @Environment(SessionStore.self) private var session

    @State private var email = ""
    @State private var password = ""

    var body: some View {

        VStack(spacing: 20) {

            Text("Academic Control")
                .font(.largeTitle)

            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Login") {

                session.login(
                    email: email,
                    password: password
                )

            }
            .buttonStyle(.borderedProminent)

        }//: VStack
        .padding()
    }
}

#Preview {
    LoginView()
}
