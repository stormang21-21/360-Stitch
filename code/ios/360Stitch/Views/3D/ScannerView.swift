import SwiftUI
import ARKit
import RealityKit

struct ScannerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var captureService = ObjectCaptureService()
    @State private var show3DViewer = false
    
    var body: some View {
        ZStack {
            ARWrapperView(captureService: captureService)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button("Back") {
                        dismiss()
                    }
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    Spacer()
                }
                Spacer()
                
                if captureService.isScanning {
                    Text(captureService.guidanceText)
                        .font(.headline).foregroundColor(.white)
                        .padding().background(Color.black.opacity(0.6)).cornerRadius(12)
                        .padding(.bottom, 10)
                }
                
                if captureService.isScanning {
                    ZStack {
                        Circle().stroke(Color.white.opacity(0.3), lineWidth: 8).frame(width: 80, height: 80)
                        Circle().trim(from: 0, to: captureService.progress)
                            .stroke(Color.green, lineWidth: 8).frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        Text("\(Int(captureService.progress * 100))%")
                            .font(.title2).fontWeight(.bold).foregroundColor(.white)
                    }.padding(.bottom, 30)
                }
                
                VStack(spacing: 15) {
                    if !captureService.isScanning && !captureService.scanComplete {
                        Button(action: { captureService.startScan() }) {
                            Text("Start 3D Scan").font(.title2).fontWeight(.bold)
                                .foregroundColor(.white).frame(width: 200, height: 60)
                                .background(Color.green).cornerRadius(30)
                        }
                    }
                    if captureService.scanComplete {
                        Button(action: { show3DViewer.toggle() }) {
                            Text(show3DViewer ? "Back to Scan" : "View 3D Room")
                                .font(.title2).fontWeight(.bold)
                                .foregroundColor(.white).frame(width: 200, height: 60)
                                .background(Color.blue).cornerRadius(30)
                        }
                        Button(action: { captureService.startScan() }) {
                            Text("Scan Again").font(.title2).fontWeight(.bold)
                                .foregroundColor(.white).frame(width: 200, height: 60)
                                .background(Color.orange).cornerRadius(30)
                        }
                    }
                    Text(captureService.statusText).font(.caption).foregroundColor(.white)
                        .padding().background(Color.black.opacity(0.6)).cornerRadius(12)
                }.padding(.bottom, 40)
            }
            
            // 3D Viewer overlay - keeps same AR session alive
            if show3DViewer {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        VStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Text("🏠 3D Room View")
                                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                                Text("Walk around to see the mesh")
                                    .font(.caption).foregroundColor(.gray)
                                Text("Tap outside to go back")
                                    .font(.caption).foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(12)
                            .padding(.bottom, 40)
                            Spacer()
                        }
                    )
                    .onTapGesture { show3DViewer = false }
            }
        }
    }
}

struct ARWrapperView: UIViewRepresentable {
    @ObservedObject var captureService: ObjectCaptureService
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        arView.automaticallyConfigureSession = false
        arView.debugOptions = [.showSceneUnderstanding]
        
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .meshWithClassification
        config.environmentTexturing = .automatic
        arView.session.run(config)
        
        arView.session.delegate = context.coordinator
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if captureService.isScanning {
                captureService.updateProgress()
            }
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARWrapperView
        
        init(_ parent: ARWrapperView) { self.parent = parent; super.init() }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            if anchors.contains(where: { $0 is ARMeshAnchor }) {
                parent.captureService.hasMesh = true
            }
        }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            if anchors.contains(where: { $0 is ARMeshAnchor }) {
                parent.captureService.hasMesh = true
            }
        }
    }
}
