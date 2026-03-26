//
//  QRHeader.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI

struct QRHeader: View {

    let offset: Double

    let maxQR: CGFloat = 260
    let minQR: CGFloat = 120

    private var qrSize: CGFloat {
        let shrink = max(0, offset)
        return max(maxQR - shrink, minQR)
    }

    private var progress: CGFloat {
        (qrSize - minQR) / (maxQR - minQR)
    }

    var body: some View {
        VStack(spacing: 16) {

            Text("Attendance QR")
                .font(.headline)
                .foregroundColor(.textPrimary)
                .opacity(progress)

            Rectangle()
                .fill(.secondaryC.opacity(0.2))
                .frame(width: qrSize, height: qrSize)
        }
        .padding(20)
        .padding(.bottom, 5)
        .padding(.horizontal, 10)
        .background(.primaryC.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    QRHeader(offset: 0)
}
