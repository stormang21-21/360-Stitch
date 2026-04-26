# 360 Stitch

**Created:** 2026-04-25
**Status:** Planning
**Telegram Group:** Retromac1_Main
**Telegram Topic ID:** 49
**Group ID:** -1003830328640

## Goals
- Build hybrid 360° panorama stitching app
- Mobile capture → Local stitch → Cloud enhance → 3D viewer
- Support both LiDAR and regular camera devices
- Real-time preview with high-quality final output

## Tech Stack
- **iOS:** SwiftUI + ARKit + CoreMotion
- **Stitching:** OpenPano + OpenCV
- **Cloud:** Python/FastAPI + OpenCV
- **3D Viewer:** Three.js / RealityKit
- **Processing:** GPU-accelerated stitching

## Architecture
```
Mobile App (capture) → Local Processing (stitch) → Cloud (enhance) → 3D Viewer
```

## Key Features
- Guided capture with ARKit motion tracking
- Real-time stitching preview
- Cloud enhancement for quality
- Export to multiple formats (OBJ, GLB, Equirectangular)
- Vision Pro support
- Community sharing

## Research Sources
- Teleport 360 Camera (HDReye Technologies)
- OpenPano (ppwwyyxx/OpenPano)
- PanoramaStitching (fluidpixel/PanoramaStitching)
- SwiftUI-LiDAR (cedanmisquith/SwiftUI-LiDAR)
- 360ls/stitcher (Real-time multi-camera)
