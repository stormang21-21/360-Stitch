import Foundation
import RealityKit
import ARKit

class ObjectCaptureService: ObservableObject {
    @Published var isScanning = false
    @Published var progress: Double = 0.0
    @Published var statusText = "Ready"
    @Published var guidanceText = "Point at room and tap to start"
    @Published var scanComplete = false
    @Published var hasMesh = false
    @Published var meshAnchors: [ARMeshAnchor] = []
    
    private let scanDuration: TimeInterval = 15
    private var scanStartTime: Date?
    private var progressTimer: Timer?
    
    func updateMeshAnchors(_ anchors: [ARMeshAnchor]) {
        DispatchQueue.main.async {
            self.meshAnchors = anchors
            self.hasMesh = !anchors.isEmpty
        }
    }
    
    func startScan() {
        DispatchQueue.main.async {
            self.progress = 0.0
            self.scanComplete = false
            self.isScanning = true
            self.hasMesh = false
            self.meshAnchors = []
            self.scanStartTime = .now
            
            self.statusText = "Scanning room... 0%"
            self.guidanceText = "Slowly walk around to capture the room"
            
            // Start a timer to update progress
            self.progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                self?.updateProgress()
            }
        }
    }
    
    func updateProgress() {
        guard let startTime = scanStartTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let newProgress = min(elapsed / scanDuration, 1.0)
        
        DispatchQueue.main.async {
            self.progress = newProgress
            let pct = Int(newProgress * 100)
            self.statusText = "Scanning room... \(pct)%"
            self.guidanceText = self.getGuidance(pct: pct)
            
            if newProgress >= 1.0 {
                self.finishScan()
            }
        }
    }
    
    private func finishScan() {
        progressTimer?.invalidate()
        progressTimer = nil
        
        DispatchQueue.main.async {
            self.isScanning = false
            self.scanComplete = true
            
            if self.hasMesh {
                self.statusText = "Room scan complete! \(self.meshAnchors.count) surfaces"
                self.guidanceText = "Tap 'Export USDZ' to save"
            } else {
                self.statusText = "Scan complete (no mesh detected)"
                self.guidanceText = "Tap 'Export USDZ' to try anyway"
            }
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
