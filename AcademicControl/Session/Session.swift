//
//  SessionStore.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FirebaseCore

@Observable
class Session {

    var currentUser: User?

    // MARK: - Email & Password Login
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
            if let user = result?.user {
                self.saveUserToFirestore(user: user)
                self.currentUser = User(
                    id: user.uid,
                    name: user.displayName ?? "Student",
                    email: user.email ?? "",
                    role: .student
                )
            }
        }
    }

    // MARK: - Register
    func register(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Register error: \(error.localizedDescription)")
                return
            }
            if let user = result?.user {
                // Save display name to Firebase Auth profile
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { _ in }

                self.saveUserToFirestore(user: user, name: name)
                self.currentUser = User(
                    id: user.uid,
                    name: name,
                    email: user.email ?? "",
                    role: .student
                )
            }
        }
    }

    // MARK: - Google Sign-In
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google Sign-In error: \(error.localizedDescription)")
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase auth error: \(error.localizedDescription)")
                    return
                }
                if let firebaseUser = authResult?.user {
                    self.saveUserToFirestore(user: firebaseUser)
                    self.currentUser = User(
                        id: firebaseUser.uid,
                        name: firebaseUser.displayName ?? "Student",
                        email: firebaseUser.email ?? "",
                        role: .student
                    )
                }
            }
        }
    }

    // MARK: - Logout
    func logout() {
        do {
            try Auth.auth().signOut()
            currentUser = nil
        } catch {
            print("Logout error: \(error.localizedDescription)")
        }
    }

    // MARK: - Save to Firestore
    private func saveUserToFirestore(user: FirebaseAuth.User, name: String = "") {
        let db = Firestore.firestore()
        db.collection("users").document(user.uid).setData([
            "email": user.email ?? "",
            "name": name.isEmpty ? (user.displayName ?? "") : name,
            "createdAt": Timestamp(date: Date())
        ], merge: true) { error in
            if let error = error {
                print("Firestore error: \(error.localizedDescription)")
            }
        }
    }
}
