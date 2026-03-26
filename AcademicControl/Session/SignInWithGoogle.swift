//
//  SessionStore.swift
//  AcademicControl
//
//  Created by Emiliano Ruíz Plancarte on 25/03/26.
//

import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore

//MARK: Sign in with Google
func signInWithGoogle() {
    // Get the root view controller
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
            // User is now signed in!
            print("Signed in as \(authResult?.user.email ?? "unknown")")
        }
    }
}

//MARK: Save e-mail to Firebase
func saveUserToFirestore(user: FirebaseAuth.User) {
    let db = Firestore.firestore()
    db.collection("users").document(user.uid).setData([
        "email": user.email ?? "",
        "createdAt": Timestamp(date: Date())
    ], merge: true) { error in
        if let error = error {
            print("Firestore error: \(error.localizedDescription)")
        }
    }
}
