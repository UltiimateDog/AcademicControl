//
//  QRCodeView.swift
//  AcademicControl
//
//  Created by Rafael on 09/03/26.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {

    let studentId: String
    let studentName: String
    let courseId: String
    let courseName: String

    // El QR se regenera cada 60 segundos
    @State private var qrImage: UIImage?
    @State private var secondsLeft: Int = 60
    @State private var timer: Timer?

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    var body: some View {
        VStack(spacing: 24) {

            Text("Attendance QR")
                .font(.title2.bold())

            Text(courseName)
                .font(.headline)
                .foregroundStyle(.secondary)

            // ── QR Image ──
            Group {
                if let img = qrImage {
                    Image(uiImage: img)
                        .interpolation(.none)         // sin blur al escalar
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .padding(12)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 6)
                } else {
                    ProgressView()
                        .frame(width: 220, height: 220)
                }
            }

            // ── Countdown ──
            HStack(spacing: 6) {
                Image(systemName: "clock")
                Text("Expires in \(secondsLeft)s")
                    .monospacedDigit()
            }
            .font(.subheadline)
            .foregroundStyle(secondsLeft <= 10 ? .red : .secondary)

            Text("Show this QR to your professor")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
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

        // Escalar a alta resolución
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))

        if let cgImage = context.createCGImage(scaled, from: scaled.extent) {
            qrImage = UIImage(cgImage: cgImage)
        }
    }

    // MARK: - Timer (regenera cada 60s)

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
    QRCodeView(
        studentId: "abc123",
        studentName: "Alice",
        courseId: "course1",
        courseName: "Mathematics"
    )
}
