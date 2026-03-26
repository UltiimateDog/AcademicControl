//
//  Session.swift
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
    
    // MARK: - Start
    
    func start() {
        Auth.auth().addStateDidChangeListener { _, user in
            if let user = user {
                self.fetchAndSetUser(uid: user.uid)
            } else {
                DispatchQueue.main.async {
                    self.currentUser = nil
                }
            }
        }
    }

    // MARK: - Fetch user from Firestore (reads the real role)
    private func fetchAndSetUser(uid: String) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Firestore fetch error: \(error.localizedDescription)")
                return
            }
            guard let data = snapshot?.data() else {
                print("No user document found for uid: \(uid)")
                return
            }
            let roleString = data["role"] as? String ?? "student"
            let role = User.Role(rawValue: roleString) ?? .student

            DispatchQueue.main.async {
                self.currentUser = User(
                    id: uid,
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    role: role
                )
            }
        }
    }

    // MARK: - Email & Password Login
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                return
            }
            if let user = result?.user {
                // Reads role from Firestore instead of hardcoding .student
                self.fetchAndSetUser(uid: user.uid)
            }
        }
    }

    // MARK: - Register (new users always start as .student)
    func register(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Register error: \(error.localizedDescription)")
                return
            }
            if let user = result?.user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges { _ in }

                // Save to Firestore with role: student by default
                self.saveUserToFirestore(uid: user.uid, email: user.email ?? "", name: name)

                DispatchQueue.main.async {
                    self.currentUser = User(
                        id: user.uid,
                        name: name,
                        email: user.email ?? "",
                        role: .student
                    )
                }
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
                    let db = Firestore.firestore()
                    let ref = db.collection("users").document(firebaseUser.uid)

                    // Check if user already exists in Firestore
                    ref.getDocument { snapshot, _ in
                        if snapshot?.exists == true {
                            // Already has a role — just fetch it
                            self.fetchAndSetUser(uid: firebaseUser.uid)
                        } else {
                            // First time Google login — create as student
                            self.saveUserToFirestore(
                                uid: firebaseUser.uid,
                                email: firebaseUser.email ?? "",
                                name: firebaseUser.displayName ?? ""
                            )
                            DispatchQueue.main.async {
                                self.currentUser = User(
                                    id: firebaseUser.uid,
                                    name: firebaseUser.displayName ?? "",
                                    email: firebaseUser.email ?? "",
                                    role: .student
                                )
                            }
                        }
                    }
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

    // MARK: - Save to Firestore (only on first registration)
    private func saveUserToFirestore(uid: String, email: String, name: String) {
        let db = Firestore.firestore()
        // merge: false so it doesn't overwrite an existing role if somehow called twice
        db.collection("users").document(uid).setData([
            "email": email,
            "name": name,
            "role": "student",
            "createdAt": Timestamp(date: Date())
        ], merge: false) { error in
            if let error = error {
                print("Firestore save error: \(error.localizedDescription)")
            }
        }
    }
}
