import SwiftUI

// MARK: - Progress Bar
struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        VStack {
            HStack {
                Text("Progress")
                    .font(.caption)
                    .foregroundColor(.white)
                Spacer()
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .foregroundColor(.white.opacity(0.3))
                        .cornerRadius(4)
                    
                    Rectangle()
                        .frame(width: geometry.size.width * progress, height: 8)
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
        .padding()
        .background(Color.black.opacity(0.5))
        .cornerRadius(12)
    }
}

// MARK: - Capture Button
struct CaptureButton: View {
    let isCapturing: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isCapturing ? Color.red : Color.blue)
                    .frame(width: 80, height: 80)
                
                if isCapturing {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: 60, height: 60)
                } else {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 70, height: 70)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Status Badge
struct StatusBadge: View {
    let text: String
    let isComplete: Bool
    
    var body: some View {
        HStack {
            Circle()
                .fill(isComplete ? Color.green : Color.yellow)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(8)
        .background(Color.black.opacity(0.6))
        .cornerRadius(16)
    }
}