import SwiftUI

struct AROverlayView: View {
    @ObservedObject var captureManager: CaptureManager
    
    var body: some View {
        ZStack {
            // Capture Guidance Circle
            Circle()
                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                .frame(width: 200, height: 200)
                .overlay(
                    Text(captureManager.guideText)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                )
                .position(x: UIScreen.main.bounds.width / 2, y: 300)
            
            // Orientation Indicator
            OrientationIndicator(angle: captureManager.currentAngle)
                .frame(width: 100, height: 100)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 200)
            
            // Progress Ring
            if captureManager.isCapturing {
                ProgressRing(progress: captureManager.progress)
                    .frame(width: 80, height: 80)
                    .position(x: UIScreen.main.bounds.width - 60, y: 100)
            }
        }
    }
}

struct OrientationIndicator: View {
    let angle: Double
    
    var body: some View {
        Circle()
            .stroke(Color.white.opacity(0.3), lineWidth: 3)
            .overlay(
                Circle()
                    .trim(from: 0, to: angle / 360)
                    .stroke(Color.green, lineWidth: 3)
            )
            .overlay(
                Text("\(Int(angle))°")
                    .font(.caption)
                    .foregroundColor(.white)
            )
    }
}

struct ProgressRing: View {
    let progress: Double
    
    var body: some View {
        Circle()
            .stroke(Color.white.opacity(0.3), lineWidth: 4)
            .overlay(
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue, lineWidth: 4)
            )
            .overlay(
                Text("\(Int(progress * 100))%")
                    .font(.caption2)
                    .foregroundColor(.white)
            )
    }
}