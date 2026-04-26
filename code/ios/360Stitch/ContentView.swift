import SwiftUI
import ARKit

struct ContentView: View {
    @StateObject private var captureManager = CaptureManager()
    @State private var showPreview = false
    @State private var show3DScanner = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Camera Preview
                CameraPreviewView(captureManager: captureManager)
                    .edgesIgnoringSafeArea(.all)
                
                // AR Overlay (non-interactive)
                AROverlayView(captureManager: captureManager)
                    .edgesIgnoringSafeArea(.top)
                    .allowsHitTesting(false)
                
                // Status Badge (non-interactive)
                VStack {
                    HStack {
                        Spacer()
                        StatusBadge(text: captureManager.statusText, isComplete: captureManager.isComplete)
                            .padding()
                    }
                    Spacer()
                }
                .allowsHitTesting(false)
            }
            .overlay(
                // Controls on top (interactive)
                VStack {
                    // Mode Selector at top
                    HStack(spacing: 12) {
                        Button(action: {
                            print("360° mode")
                        }) {
                            Label("360°", systemImage: "camera.rotate")
                                .font(.caption)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                        
                        Button(action: {
                            show3DScanner = true
                        }) {
                            Label("3D Scan", systemImage: "cube")
                                .font(.caption)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .cornerRadius(20)
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Progress Bar
                    if captureManager.isCapturing || captureManager.isComplete {
                        VStack {
                            ProgressBar(progress: captureManager.progress)
                                .padding(.horizontal, 40)
                            
                            Text("Images: \(captureManager.capturedImages.count)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.top, 5)
                        }
                        .padding(.bottom, 20)
                    }
                    
                    // Capture Button
                    CaptureButton(isCapturing: captureManager.isCapturing) {
                        print("👆 BUTTON TAPPED!")
                        captureManager.toggleCapture()
                    }
                    .padding(.bottom, 40)
                    
                    // Stop & View
                    if captureManager.isCapturing {
                        Button("Stop & View (\(captureManager.capturedImages.count))") {
                            captureManager.stopCapture()
                            showPreview = true
                        }
                        .padding(.bottom, 20)
                    }
                    
                    // View Captures
                    if captureManager.isComplete && !captureManager.capturedImages.isEmpty {
                        Button("View \(captureManager.capturedImages.count) Captures") {
                            showPreview = true
                        }
                        .padding(.bottom, 20)
                    }
                }
            )
            .sheet(isPresented: $showPreview) {
                PreviewView(images: captureManager.capturedImages)
            }
            .fullScreenCover(isPresented: $show3DScanner) {
                ScannerView()
            }
            .onAppear {
                captureManager.startMotionTracking()
                captureManager.requestCameraPermission()
            }
            .onChange(of: captureManager.isComplete) { completed in
                if completed {
                    showPreview = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
