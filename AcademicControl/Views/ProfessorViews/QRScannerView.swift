//
//  QRScannerView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct QRScannerView: View {

    var body: some View {

        VStack(spacing: 20) {

            Text("QR Scanner")

            Text("Camera preview will appear here")

        }
        .onAppear {

            // TODO: Integrate QR scanner (AVFoundation or library)

        }
    }
}

#Preview {
    QRScannerView()
}
