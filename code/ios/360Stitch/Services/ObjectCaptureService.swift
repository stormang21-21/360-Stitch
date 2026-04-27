import Foundation
import ARKit

@MainActor
class ObjectCaptureService: ObservableObject {
    @Published var isScanning = false
    @Published var progress: Double = 0.0
    @Published var statusText = "Ready"
    @Published var guidanceText = "Point at room and tap to start"
    @Published var scanComplete = false
    @Published var hasMesh = false
    @Published var meshAnchors: [ARMeshAnchor] = []
    
    private var scanStartTime: Date?
    private var progressTimer: Timer?
    
    func updateMeshAnchors(_ anchors: [ARMeshAnchor]) {
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            self.meshAnchors = anchors
            self.hasMesh = !anchors.isEmpty
        }
    }
    
    func startScan() {
        progress = 0.0
        scanComplete = false
        isScanning = true
        hasMesh = false
        meshAnchors = []
        scanStartTime = Date()
        
        statusText = "Scanning room... 0%"
        guidanceText = "Slowly walk around to capture the room"
        
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateProgress()
            }
        }
    }
    
    func updateProgress() {
        guard let startTime = scanStartTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let newProgress = min(elapsed / 15.0, 1.0)
        
        progress = newProgress
        let pct = Int(newProgress * 100)
        statusText = "Scanning room... \(pct)%"
        guidanceText = getGuidance(pct: pct)
        
        if newProgress >= 1.0 {
            finishScan()
        }
    }
    
    private func finishScan() {
        progressTimer?.invalidate()
        progressTimer = nil
        isScanning = false
        scanComplete = true
        
        if hasMesh {
            statusText = "Room scan complete! \(meshAnchors.count) surfaces"
            guidanceText = "Tap 'Export USDZ' to save"
        } else {
            statusText = "Scan complete (no mesh detected)"
            guidanceText = "Tap 'Export USDZ' to try anyway"
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
