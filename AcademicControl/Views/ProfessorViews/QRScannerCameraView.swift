//
//  QRScannerCameraView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct QRScannerCameraView: View {

    var body: some View {

        VStack(spacing: 20) {

            Image(systemName: "camera")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("Camera View")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Camera preview will appear here")
                .foregroundColor(.secondary)

        }
        .padding()
        .navigationTitle("Scan QR")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {

            // TODO: Request camera permission

            // TODO: Initialize AVCaptureSession

            // TODO: Display camera preview layer

            // TODO: Detect QR codes

            // TODO: Parse QR content

            // TODO: Mark attendance when valid code is detected

        }
    }
}

#Preview {
    QRScannerCameraView()
}
