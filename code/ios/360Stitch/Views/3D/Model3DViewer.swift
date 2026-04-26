import SwiftUI
import RealityKit
import ARKit

struct Room3DViewer: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ARMeshViewer()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Button("Done") { dismiss() }
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    Spacer()
                }
                Spacer()
                VStack(spacing: 8) {
                    Text("🔄 Walk around to view")
                    Text("Room mesh is active")
                }
                .font(.caption).foregroundColor(.white)
                .padding().background(Color.black.opacity(0.6)).cornerRadius(12)
                .padding(.bottom, 40)
            }
        }
    }
}

struct ARMeshViewer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        // Configure BEFORE running
        arView.automaticallyConfigureSession = false
        arView.debugOptions = [.showSceneUnderstanding]
        
        let config = ARWorldTrackingConfiguration()
        config.sceneReconstruction = .meshWithClassification
        arView.session.run(config)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
