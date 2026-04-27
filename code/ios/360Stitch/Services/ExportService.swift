import Foundation
import ARKit
import ModelIO
import MetalKit
import UIKit

class ExportService: ObservableObject {
    @Published var isExporting = false
    @Published var exportProgress: Double = 0.0
    @Published var exportMessage = ""
    @Published var exportedURL: URL?
    
    func exportToUSDZ(meshAnchors: [ARMeshAnchor]) async -> URL? {
        isExporting = true
        exportProgress = 0.0
        exportMessage = "Creating 3D model..."
        
        // Delay to allow UI to update before heavy work
        try? await Task.sleep(for: .milliseconds(50))
        
        do {
            guard !meshAnchors.isEmpty else {
                exportMessage = "❌ No mesh data to export. Try scanning again."
                // Keep isExporting true briefly so user sees error, then reset
                try? await Task.sleep(for: .seconds(2))
                isExporting = false
                return nil
            }
            
            let device = MTLCreateSystemDefaultDevice()!
            let allocator = MTKMeshBufferAllocator(device: device)
            let asset = MDLAsset()
            
            for (index, anchor) in meshAnchors.enumerated() {
                exportProgress = Double(index) / Double(meshAnchors.count)
                
                let geometry = anchor.geometry
                let vertexCount = geometry.vertices.count
                
                // Get vertex data
                let vertexData = Data(bytesNoCopy: geometry.vertices.buffer.contents(),
                                     count: geometry.vertices.buffer.length,
                                     deallocator: .none)
                
                // Get index data - for triangles, index count = face count * 3
                let indexCount = geometry.faces.count * 3
                let bytesPerIndex = geometry.faces.bytesPerIndex
                let indexData = Data(bytesNoCopy: geometry.faces.buffer.contents(),
                                    count: geometry.faces.buffer.length,
                                    deallocator: .none)
                
                // Vertex descriptor
                let vertexDescriptor = MDLVertexDescriptor()
                vertexDescriptor.attributes[0] = MDLVertexAttribute(
                    name: MDLVertexAttributePosition,
                    format: .float3,
                    offset: 0,
                    bufferIndex: 0
                )
                vertexDescriptor.layouts[0] = MDLVertexBufferLayout(stride: geometry.vertices.stride)
                
                // Create buffers
                let vertexBuffer = allocator.newBuffer(with: vertexData, type: .vertex)
                let indexBuffer = allocator.newBuffer(with: indexData, type: .index)
                
                // Create submesh (always use UInt32, convert if needed)
                let submesh: MDLSubmesh
                if bytesPerIndex == 2 {
                    // Convert UInt16 indices to UInt32
                    let raw16 = indexData.withUnsafeBytes { ptr in
                        ptr.bindMemory(to: UInt16.self).map { UInt32($0) }
                    }
                    let indexData32 = Data(bytes: raw16, count: raw16.count * 4)
                    let indexBuffer32 = allocator.newBuffer(with: indexData32, type: .index)
                    submesh = MDLSubmesh(
                        indexBuffer: indexBuffer32,
                        indexCount: indexCount,
                        indexType: .uInt32,
                        geometryType: .triangles,
                        material: nil
                    )
                } else {
                    submesh = MDLSubmesh(
                        indexBuffer: indexBuffer,
                        indexCount: indexCount,
                        indexType: .uInt32,
                        geometryType: .triangles,
                        material: nil
                    )
                }
                
                // Create mesh
                let mesh = MDLMesh(
                    vertexBuffer: vertexBuffer,
                    vertexCount: vertexCount,
                    descriptor: vertexDescriptor,
                    submeshes: [submesh]
                )
                
                asset.add(mesh)
            }
            
            let objectCount = asset.childObjects.count
            print("📦 Asset contains \(objectCount) objects")
            
            exportProgress = 0.8
            exportMessage = "Saving USDZ file..."
            
            // Save to documents
            let filename = "RoomScan_\(Int(Date().timeIntervalSince1970))"
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documentsURL.appendingPathComponent("\(filename).usdz")
            
            print("📦 Exporting \(objectCount) objects to \(url.path)")
            
            // Export to USDZ
            try asset.export(to: url)
            
            // Verify file was created
            if FileManager.default.fileExists(atPath: url.path) {
                let fileSize = try FileManager.default.attributesOfItem(atPath: url.path)[.size] as? Int ?? 0
                print("✅ USDZ saved: \(url.path) (\(fileSize) bytes)")
                exportProgress = 1.0
                exportMessage = "✅ Exported! (\(meshAnchors.count) surfaces)"
                exportedURL = url
            } else {
                throw NSError(domain: "ExportService", code: -1, userInfo: [NSLocalizedDescriptionKey: "File not created"])
            }
            
            isExporting = false
            return url
            
        } catch {
            exportMessage = "❌ Export failed: \(error.localizedDescription)"
            print("❌ Export error: \(error)")
            print("❌ Error details: \(error.localizedDescription)")
            print("❌ Error code: \((error as NSError).code)")
            print("❌ Error domain: \((error as NSError).domain)")
            try? await Task.sleep(for: .seconds(4))
            isExporting = false
            return nil
        }
    }
}
