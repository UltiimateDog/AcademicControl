//
//  QRHeader.swift
//  AcademicControl
//
//  Created by Rafael on 25/03/26.
//


import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRHeader: View {

    let offset: Double

    // Datos reales del alumno — pásalos desde StudentDashboardView
    let studentId: String
    let studentName: String
    let courseId: String
    let courseName: String

    let maxQR: CGFloat = 260
    let minQR: CGFloat = 120

    @State private var qrImage: UIImage?
    @State private var secondsLeft: Int = 60
    @State private var timer: Timer?

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

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

            // QR real
            Group {
                if let img = qrImage {
                    Image(uiImage: img)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(width: qrSize, height: qrSize)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    ProgressView()
                        .frame(width: qrSize, height: qrSize)
                }
            }

            // Countdown pequeño
            if progress > 0.5 {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text("\(secondsLeft)s")
                        .monospacedDigit()
                }
                .font(.caption)
                .foregroundStyle(secondsLeft <= 10 ? .red : .secondary)
                .opacity(progress)
            }
        }
        .padding(20)
        .padding(.bottom, 5)
        .padding(.horizontal, 10)
        .background(.primaryC.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            generateQR()
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    // MARK: - QR Generation

    private func generateQR() {
        let payload = Attendance.QRPayload(
            studentId: studentId,
            studentName: studentName,
            courseId: courseId,
            courseName: courseName,
            expiresAt: Date().addingTimeInterval(60).timeIntervalSince1970
        )
        guard let data = try? JSONEncoder().encode(payload) else { return }
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else { return }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        if let cgImage = context.createCGImage(scaled, from: scaled.extent) {
            qrImage = UIImage(cgImage: cgImage)
        }
    }

    private func startTimer() {
        secondsLeft = 60
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if secondsLeft > 1 {
                secondsLeft -= 1
            } else {
                generateQR()
                secondsLeft = 60
            }
        }
    }
}

#Preview {
    QRHeader(
        offset: 0,
        studentId: "abc123",
        studentName: "Alice",
        courseId: "course1",
        courseName: "Mathematics"
    )
}
