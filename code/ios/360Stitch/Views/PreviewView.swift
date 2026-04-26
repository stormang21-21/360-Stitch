import SwiftUI
import Photos

struct PreviewView: View {
    let images: [UIImage]
    @Environment(\.dismiss) var dismiss
    @State private var stitchedImage: UIImage?
    @State private var isStitching = false
    @State private var isSaving = false
    @State private var saveMessage = ""
    @State private var showSavedAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Stitched Result or Image Grid
                if let stitched = stitchedImage {
                    VStack {
                        Text("Stitched Panorama")
                            .font(.headline)
                            .padding(.top)
                        
                        Image(uiImage: stitched)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                            .padding()
                        
                        Text("\(images.count) images combined")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 8) {
                            ForEach(images.indices, id: \.self) { index in
                                Image(uiImage: images[index])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    if isStitching {
                        ProgressView("Stitching...")
                            .padding()
                    } else if let stitched = stitchedImage {
                        HStack(spacing: 20) {
                            Button(action: {
                                print("💾 Save Panorama tapped!")
                                saveImage(stitched)
                            }) {
                                Text("Save Panorama")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                            
                            Button(action: {
                                print("🗑️ Discard stitched tapped!")
                                stitchedImage = nil
                            }) {
                                Text("Discard")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                    } else {
                        HStack(spacing: 20) {
                            Button(action: {
                                print("🧵 Stitch tapped!")
                                stitchImages()
                            }) {
                                Text("Stitch (\(images.count))")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                            
                            Button(action: {
                                print("💾 Save tapped!")
                                saveAllImages()
                            }) {
                                Text("Save (\(images.count))")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                            
                            Button(action: {
                                print("🗑️ Discard tapped!")
                                dismiss()
                            }) {
                                Text("Discard")
                                    .fontWeight(.semibold)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                        }
                    }
                    
                    if !saveMessage.isEmpty {
                        Text(saveMessage)
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(.top, 5)
                    }
                }
                .padding()
            }
            .navigationTitle("Captured Images")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .alert("Saved!", isPresented: $showSavedAlert) {
                Button("OK") { }
            } message: {
                Text("Images saved to your photo library!")
            }
        }
    }
    
    // MARK: - Stitch Images
    func stitchImages() {
        isStitching = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let result = createHorizontalPanorama(images)
            
            DispatchQueue.main.async {
                stitchedImage = result
                isStitching = false
            }
        }
    }
    
    func createHorizontalPanorama(_ images: [UIImage]) -> UIImage {
        guard let firstImage = images.first else { return UIImage() }
        
        let imgHeight = firstImage.size.height
        let imgWidth = firstImage.size.width
        let totalWidth = Int(imgWidth * CGFloat(images.count) * 0.7)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: totalWidth, height: Int(imgHeight)))
        
        return renderer.image { context in
            for (index, image) in images.enumerated() {
                let xPosition = CGFloat(index) * imgWidth * 0.7
                let rect = CGRect(x: xPosition, y: 0, width: imgWidth, height: imgHeight)
                image.draw(in: rect)
            }
        }
    }
    
    // MARK: - Save Single Image using Photos framework only
    func saveImage(_ image: UIImage) {
        isSaving = true
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    self.saveMessage = "⚠️ Enable Photos access in Settings"
                    self.isSaving = false
                }
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                DispatchQueue.main.async {
                    self.isSaving = false
                    if success {
                        self.saveMessage = "✅ Saved!"
                        self.showSavedAlert = true
                    } else {
                        self.saveMessage = "❌ \(error?.localizedDescription ?? "Unknown error")"
                    }
                }
            }
        }
    }
    
    // MARK: - Save All Images using Photos framework only
    func saveAllImages() {
        isSaving = true
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    self.saveMessage = "⚠️ Enable Photos access in Settings"
                    self.isSaving = false
                }
                return
            }
            
            let imagesToSave = self.images
            
            PHPhotoLibrary.shared().performChanges({
                for image in imagesToSave {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
            }) { success, error in
                DispatchQueue.main.async {
                    self.isSaving = false
                    if success {
                        self.saveMessage = "✅ Saved \(imagesToSave.count) images!"
                        self.showSavedAlert = true
                    } else {
                        self.saveMessage = "❌ \(error?.localizedDescription ?? "Unknown error")"
                    }
                }
            }
        }
    }
}
