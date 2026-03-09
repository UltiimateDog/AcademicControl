//
//  QRCodeView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct QRCodeView: View {

    var body: some View {

        VStack(spacing: 20) {

            Text("Attendance QR")

            Rectangle()
                .frame(width: 220, height: 220)

            Text("QR Code Placeholder")

        }
        .onAppear {

            // TODO: Generate QR with student ID

        }
    }
}

#Preview {
    QRCodeView()
}
