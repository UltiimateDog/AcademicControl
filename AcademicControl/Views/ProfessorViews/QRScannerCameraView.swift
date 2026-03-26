//
//  QRScannerCameraView.swift
//  AcademicControl
//
//  Created by Ultiimate Dog on 09/03/26.
//

import SwiftUI
import AVFoundation
import FirebaseFirestore

// MARK: - Coordinator (AVFoundation bridge)

class QRScannerCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {

    var onQRDetected: ((String) -> Void)?

    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        guard
            let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            obj.type == .qr,
            let value = obj.stringValue
        else { return }

        DispatchQueue.main.async {
            self.onQRDetected?(value)
        }
    }
}

// MARK: - Camera UIView

class QRCameraPreview: UIView {

    var previewLayer: AVCaptureVideoPreviewLayer?

    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
}

// MARK: - UIViewRepresentable wrapper

struct CameraPreviewView: UIViewRepresentable {

    let session: AVCaptureSession

    func makeUIView(context: Context) -> QRCameraPreview {
        let view = QRCameraPreview()
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        view.previewLayer = layer
        return view
    }

    func updateUIView(_ uiView: QRCameraPreview, context: Context) {
        uiView.previewLayer?.frame = uiView.bounds
    }
}

// MARK: - Main View

struct QRScannerCameraView: View {

    // El profesor debe saber en qué curso está para filtrar
    let professorCourseId: String
    let professorCourseName: String

    @State private var captureSession = AVCaptureSession()
    @State private var coordinator = QRScannerCoordinator()

    @State private var isScanning = true
    @State private var statusMessage: String? = nil
    @State private var statusIsError = false
    @State private var lastScannedId: String = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {

            // ── Camera feed ──
            CameraPreviewView(session: captureSession)
                .ignoresSafeArea()

            // ── Overlay ──
            VStack {

                Spacer()

                // Visor cuadrado
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white, lineWidth: 3)
                    .frame(width: 240, height: 240)

                Spacer()

                // Feedback
                if let msg = statusMessage {
                    Text(msg)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(statusIsError ? Color.red.opacity(0.85) : Color.green.opacity(0.85))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom, 40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .navigationTitle("Scan QR")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { setupCamera() }
        .onDisappear { captureSession.stopRunning() }
    }

    // MARK: - Setup

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              captureSession.canAddInput(input) else {
            showStatus("Camera not available", isError: true)
            return
        }

        let output = AVCaptureMetadataOutput()
        guard captureSession.canAddOutput(output) else { return }

        captureSession.beginConfiguration()
        captureSession.addInput(input)
        captureSession.addOutput(output)
        output.metadataObjectTypes = [.qr]
        output.setMetadataObjectsDelegate(coordinator, queue: .main)
        captureSession.commitConfiguration()

        coordinator.onQRDetected = { [self] raw in
            handleQR(raw: raw)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            captureSession.startRunning()
        }
    }

    // MARK: - Handle QR

    private func handleQR(raw: String) {
        guard isScanning else { return }

        // Evitar procesar el mismo QR dos veces seguidas
        guard raw != lastScannedId else { return }
        lastScannedId = raw
        isScanning = false

        // 1. Decodificar JSON del QR
        guard
            let data = raw.data(using: .utf8),
            let payload = try? JSONDecoder().decode(Attendance.QRPayload.self, from: data)
        else {
            showStatus("Invalid QR code", isError: true)
            resumeScanning(after: 3)
            return
        }

        // 2. Verificar expiración (60 segundos)
        let expiresAt = Date(timeIntervalSince1970: payload.expiresAt)
        guard Date() < expiresAt else {
            showStatus("QR expired — ask student to refresh", isError: true)
            resumeScanning(after: 3)
            return
        }

        // 3. Verificar que el QR es para este curso
        guard payload.courseId == professorCourseId else {
            showStatus("QR is for a different course", isError: true)
            resumeScanning(after: 3)
            return
        }

        // 4. Guardar asistencia en Firestore
        saveAttendance(payload: payload)
    }

    // MARK: - Firestore

    private func saveAttendance(payload: Attendance.QRPayload) {
        let db = Firestore.firestore()
        let docId = "\(payload.studentId)_\(payload.courseId)_\(todayString())"

        // Evitar duplicados: si ya hay asistencia del alumno hoy, no registrar de nuevo
        let ref = db.collection("attendance").document(docId)

        ref.getDocument { snapshot, _ in
            if snapshot?.exists == true {
                showStatus("\(payload.studentName) already checked in today ✓", isError: false)
                resumeScanning(after: 3)
                return
            }

            ref.setData([
                "studentId": payload.studentId,
                "studentName": payload.studentName,
                "courseId": payload.courseId,
                "courseName": payload.courseName,
                "date": todayString(),
                "timestamp": Timestamp(date: Date())
            ]) { error in
                if let error = error {
                    showStatus("Error: \(error.localizedDescription)", isError: true)
                } else {
                    showStatus("\(payload.studentName) ✓ Attendance registered!", isError: false)
                }
                resumeScanning(after: 3)
            }
        }
    }

    // MARK: - Helpers

    private func todayString() -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: Date())
    }

    private func showStatus(_ msg: String, isError: Bool) {
        withAnimation {
            statusMessage = msg
            statusIsError = isError
        }
    }

    private func resumeScanning(after seconds: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            withAnimation { statusMessage = nil }
            lastScannedId = ""
            isScanning = true
        }
    }
}

#Preview {
    NavigationStack {
        QRScannerCameraView(professorCourseId: "course1", professorCourseName: "Mathematics")
    }
}
