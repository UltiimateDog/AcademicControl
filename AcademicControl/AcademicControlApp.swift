//
//  AcademicControlApp.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

@main
struct AcademicControlApp: App {
    @State private var session: SessionStore = .init()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(session)
        }
    }
}
