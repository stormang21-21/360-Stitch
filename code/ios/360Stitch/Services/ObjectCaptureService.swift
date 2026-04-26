import Foundation
import RealityKit
import ARKit
import UIKit

class ObjectCaptureService: ObservableObject {
    @Published var isScanning = false
    @Published var progress: Double = 0.0
    @Published var statusText = "Ready"
    @Published var guidanceText = "Point at room and tap to start"
    @Published var capturedPhotos = 0
    @Published var scanComplete = false
    @Published var hasMesh = false
    
    private let scanDuration: TimeInterval = 15
    private var scanStartTime: Date?
    
    func startScan() {
        capturedPhotos = 0
        progress = 0.0
        scanComplete = false
        isScanning = true
        hasMesh = false
        scanStartTime = .now
        statusText = "Scanning room... 0%"
        guidanceText = "Slowly walk around to capture the room"
    }
    
    func updateProgress() {
        guard let startTime = scanStartTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        progress = min(elapsed / scanDuration, 1.0)
        
        let pct = Int(progress * 100)
        statusText = "Scanning room... \(pct)%"
        guidanceText = getGuidance(pct: pct)
        
        if progress >= 1.0 {
            finishScan()
        }
    }
    
    private func finishScan() {
        isScanning = false
        scanComplete = true
        
        if hasMesh {
            statusText = "Room scan complete! Tap to view"
            guidanceText = "Tap 'View 3D Room'"
        } else {
            statusText = "Limited data captured"
            guidanceText = "Try scanning again"
        }
    }
    
    private func getGuidance(pct: Int) -> String {
        switch pct {
        case 0..<25: return "📸 Scan walls and ceiling"
        case 25..<50: return "📐 Capture furniture"
        case 50..<75: return "🔄 Scan the floor"
        case 75..<90: return "✨ Almost done! Corners"
        default: return "🎯 Final scan..."
        }
    }
}
