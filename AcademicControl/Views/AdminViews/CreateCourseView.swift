//
//  CreateCourseView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct CreateCourseView: View {

    @State private var name = ""

    var body: some View {

        Form {

            TextField("Course name", text: $name)

            Button("Create") {

                // TODO: Send course creation to backend

            }

        }
        .navigationTitle("New Course")
    }
}

#Preview {
    CreateCourseView()
}
