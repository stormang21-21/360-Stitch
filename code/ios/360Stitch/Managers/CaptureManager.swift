import Foundation
import ARKit
import CoreMotion
import SwiftUI

class CaptureManager: ObservableObject {
    // State
    @Published var isCapturing = false
    @Published var isComplete = false
    @Published var progress: Double = 0.0
    @Published var currentAngle: Double = 0.0
    @Published var statusText = "Ready"
    @Published var guideText = "Point camera and tap to start"
    @Published var capturedImages: [UIImage] = []
    
    // Motion Manager
    private let motionManager = CMMotionManager()
    private var yawStart: Double = 0.0
    private var lastYaw: Double = 0.0
    
    // Capture Settings
    private let targetAngle: Double = 360.0
    private let captureInterval: Double = 5.0 // degrees between captures
    private var lastCaptureAngle: Double = 0.0
    
    init() {
        // Motion tracking will be started explicitly
    }
    
    func startMotionTracking() {
        setupMotionTracking()
    }
    
    // MARK: - Camera Permission
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if !granted {
                    self.statusText = "Camera access required"
                }
            }
        }
    }
    
    // MARK: - Motion Tracking Setup
    private func setupMotionTracking() {
        guard motionManager.isDeviceMotionAvailable else {
            DispatchQueue.main.async {
                self.statusText = "Motion tracking not available"
            }
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates()
    }
    
    // MARK: - Capture Control
    func toggleCapture() {
        if isCapturing {
            stopCapture()
        } else {
            startCapture()
        }
    }
    
    private func startCapture() {
        isCapturing = true
        isComplete = false
        progress = 0.0
        capturedImages = []
        lastCaptureAngle = 0.0
        
        // Get initial yaw
        if let motion = motionManager.deviceMotion {
            yawStart = motion.attitude.yaw
            lastYaw = yawStart
            print("🎯 Capture started. Initial yaw: \(yawStart)")
        } else {
            print("⚠️ Device motion not available!")
            statusText = "Motion not available"
            isCapturing = false
            return
        }
        
        statusText = "Capturing..."
        guideText = "Slowly rotate 360°"
    }
    
    func stopCapture() {
        isCapturing = false
        isComplete = true
        statusText = capturedImages.isEmpty ? "Stopped" : "Complete!"
        guideText = capturedImages.isEmpty ? "Tap to restart" : "Tap to view"
    }
    
    // MARK: - Frame Processing
    func processFrame(_ frame: ARFrame) {
        guard isCapturing else { return }
        
        // Get current yaw from device motion
        guard let motion = motionManager.deviceMotion else { 
            print("⚠️ No device motion data")
            return 
        }
        let currentYaw = motion.attitude.yaw - yawStart
        
        lastYaw = currentYaw
        
        // Update current angle display
        let currentAngleDeg = abs(currentYaw * 180.0 / .pi)
        DispatchQueue.main.async {
            self.currentAngle = currentAngleDeg
        }
        
        // Capture image at intervals
        if currentAngleDeg - lastCaptureAngle >= captureInterval {
            captureImage(from: frame)
            lastCaptureAngle = currentAngleDeg
            print("📸 Captured image #\(self.capturedImages.count + 1) at \(Int(currentAngleDeg))°")
        }
        
        // Update progress
        let progressValue = min(currentAngleDeg / targetAngle, 1.0)
        DispatchQueue.main.async {
            self.progress = progressValue
            print("📊 Progress: \(Int(progressValue * 100))% (\(Int(currentAngleDeg))°/\(self.targetAngle)°)")
            
            if progressValue >= 1.0 {
                print("✅ CAPTURE COMPLETE! \(self.capturedImages.count) images")
                self.isComplete = true
                self.stopCapture()
            }
        }
    }
    
    // MARK: - Image Capture
    private func captureImage(from frame: ARFrame) {
        let pixelBuffer = frame.capturedImage
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return }
        
        // Fix orientation - ARKit captures in landscape, we want portrait
        let image = UIImage(cgImage: cgImage, scale: 1.0, orientation: .right)
        
        DispatchQueue.main.async {
            self.capturedImages.append(image)
            print("📸 Captured image #\(self.capturedImages.count) at \(Int(self.currentAngle))°")
        }
    }
}