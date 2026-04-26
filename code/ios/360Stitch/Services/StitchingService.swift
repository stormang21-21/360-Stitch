import Foundation
import UIKit
import AVFoundation

class StitchingService {
    
    // MARK: - Stitch Images (Placeholder - Replace with actual OpenCV when ready)
    func stitchImages(_ images: [UIImage]) async throws -> UIImage {
        guard images.count > 1 else {
            throw StitchingError.insufficientImages
        }
        
        // TODO: Implement actual OpenCV stitching
        // For now, return the first image as a placeholder
        // This allows testing the capture flow without OpenCV dependency
        
        print("📸 Stitching \(images.count) images...")
        
        // Placeholder: Return first image
        // In production, this would call OpenCV's stitcher
        return images[0]
        
        /*
        // Future OpenCV implementation:
        let mats = images.compactMap { uiImage -> Mat? in
            guard let cgImage = uiImage.cgImage else { return nil }
            return Mat(cgImage: cgImage)
        }
        
        let stitcher = try Stitcher()
        var result = Mat()
        let status = try stitcher.stitch(mats, result)
        
        guard status == .ok else {
            throw StitchingError.stitchingFailed
        }
        
        guard let cgImage = result.cgImage() else {
            throw StitchingError.conversionFailed
        }
        
        return UIImage(cgImage: cgImage)
        */
    }
    
    // MARK: - Preview Stitch (Fast, Low Quality)
    func previewStitch(_ images: [UIImage]) async throws -> UIImage {
        // For now, same as full stitch
        return try await stitchImages(images)
    }
    
    // MARK: - Helper Methods
    func resizeImage(_ image: UIImage, to size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

// MARK: - Errors
enum StitchingError: Error {
    case insufficientImages
    case stitchingFailed
    case conversionFailed
}
