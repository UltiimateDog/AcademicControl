//
//  CamaraCard.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct CamaraCard: View {
    var body: some View {
        VStack(spacing: 16) {

            Image(systemName: "camera.viewfinder")
                .font(.system(size: 48))
                .foregroundStyle(.accent)

            Text("Scan Attendance QR")
                .font(.headline)

            Text("Use the camera to scan the QR code displayed by students to register attendance.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            NavigationLink {

                QRScannerCameraView()

            } label: {

                HStack {

                    Image(systemName: "camera")

                    Text("Start Scanning")

                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(.accent)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))

            }

        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    CamaraCard()
}
