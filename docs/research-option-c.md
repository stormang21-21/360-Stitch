# 360 Stitch - Option C Research (Hybrid Approach)

**Date:** 2026-04-25
**Status:** Research Complete

---

## 📋 Executive Summary

**Option C (Hybrid)** combines the best of both worlds:
- **Local processing** for real-time preview and immediate results
- **Cloud processing** for high-quality enhancement and complex stitching
- **Mobile-first** capture with guided workflow
- **3D viewer** for immersive exploration

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    MOBILE APP (iOS)                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Capture  │  │ Preview  │  │ Local    │  │ Export   │   │
│  │ Module   │  │ Module   │  │ Stitch   │  │ Module   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│         │            │            │            │            │
│         └────────────┴────────────┴────────────┘            │
│                          │                                  │
└──────────────────────────┼──────────────────────────────────┘
                           │
                    ┌──────┴──────┐
                    │  Cloud API  │
                    │ (FastAPI)   │
                    └──────┬──────┘
                           │
                    ┌──────┴──────┐
                    │  Processing │
                    │  Pipeline   │
                    └──────┬──────┘
                           │
                    ┌──────┴──────┐
                    │  3D Viewer  │
                    │ (Three.js)  │
                    └─────────────┘
```

---

## 📱 Mobile App (iOS)

### Tech Stack
- **SwiftUI** - Modern UI framework
- **ARKit** - Camera access + motion tracking
- **CoreMotion** - Gyroscope/accelerometer data
- **OpenCV (Swift wrapper)** - Image processing
- **SceneKit/RealityKit** - 3D visualization

### Features
1. **Guided Capture**
   - ARKit-based motion tracking
   - Visual guides for overlap
   - Real-time feedback
   - HDR support

2. **Local Preview**
   - Fast stitching using OpenPano
   - Real-time preview (lower quality)
   - Immediate sharing capability

3. **Cloud Upload**
   - Automatic upload to cloud
   - Background processing
   - Progress tracking
   - Offline support

4. **3D Viewer**
   - Interactive 3D navigation
   - Export to OBJ/GLB
   - Vision Pro support
   - Share to social media

---

## ☁️ Cloud Processing Pipeline

### Tech Stack
- **Python/FastAPI** - API server
- **OpenCV + OpenPano** - Stitching algorithm
- **Celery + Redis** - Task queue
- **PostgreSQL** - Metadata storage
- **S3/Cloud Storage** - File storage

### Processing Steps
1. **Upload** - Receive images from mobile app
2. **Preprocess** - Resize, normalize, color correct
3. **Feature Detection** - SIFT/SURF/ORB features
4. **Matching** - Feature matching between images
5. **Camera Calibration** - Estimate camera poses
6. **Stitching** - Blend images into panorama
7. **Enhancement** - HDR, denoise, sharpen
8. **3D Reconstruction** - Convert to 3D model
9. **Export** - Generate OBJ/GLB/equirectangular

### API Endpoints
```
POST /api/upload         - Upload images
GET  /api/status/{id}    - Check processing status
GET  /api/result/{id}    - Download result
POST /api/enhance        - Request cloud enhancement
GET  /api/export/{id}    - Export to format
```

---

## 🔍 Research Sources

### 1. Teleport 360 Camera (HDReye Technologies)
- **App Store:** id6476905405
- **Size:** 75.8 MB
- **Rating:** 4.1/5 (64 ratings)
- **Price:** Free + IAP ($9.99 Pro, $49.99 Pro)
- **Tech:** Cloud-based stitching, guided capture
- **Strengths:** User-friendly, Vision Pro support
- **Weaknesses:** Cloud-dependent, not real-time

### 2. OpenPano
- **Repo:** `ppwwyyxx/OpenPano`
- **Tech:** C++ with OpenCV
- **Features:** Automatic panorama stitching
- **License:** MIT
- **✅ Use for:** Core stitching algorithm

### 3. PanoramaStitching
- **Repo:** `fluidpixel/PanoramaStitching`
- **Tech:** OpenCV framework for iOS/OSX
- **Features:** 360° panorama stitching
- **✅ Use for:** iOS integration

### 4. SwiftUI-LiDAR
- **Repo:** `cedanmisquith/SwiftUI-LiDAR`
- **Tech:** SwiftUI + ARKit + LiDAR
- **Features:** Real-time 3D mesh generation
- **✅ Use for:** iOS capture + 3D preview

### 5. 360ls/stitcher
- **Repo:** `360ls/stitcher`
- **Tech:** OpenCV 2.4/3
- **Features:** Real-time multi-camera stitching
- **✅ Use for:** Real-time preview stitching

---

## 📊 Comparison: Option A vs B vs C

| Feature | Option A (Cloud) | Option B (Real-time) | Option C (Hybrid) ✅ |
|---------|-----------------|---------------------|---------------------|
| **Capture** | Guided | Guided | Guided |
| **Preview** | Cloud-only | Real-time | Real-time + Cloud |
| **Quality** | High | Medium | High |
| **Speed** | Slow (upload) | Fast | Fast preview + High quality |
| **Offline** | ❌ No | ✅ Yes | ✅ Yes (preview) |
| **3D** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Vision Pro** | ✅ Yes | ❌ No | ✅ Yes |
| **Complexity** | Medium | High | Medium |
| **Cost** | Cloud hosting | Device GPU | Cloud + Device |

**Winner: Option C** - Best balance of quality, speed, and features!

---

## 🚀 Implementation Plan

### Phase 1: Research & Setup (Week 1-2)
- [x] Research complete
- [ ] Clone OpenPano and test
- [ ] Clone SwiftUI-LiDAR and test
- [ ] Set up development environment

### Phase 2: iOS Capture App (Week 3-4)
- [ ] Build SwiftUI capture interface
- [ ] Integrate ARKit motion tracking
- [ ] Add guided capture prompts
- [ ] Implement local preview stitching

### Phase 3: Cloud Pipeline (Week 5-6)
- [ ] Set up FastAPI server
- [ ] Implement OpenPano stitching
- [ ] Add task queue (Celery/Redis)
- [ ] Create API endpoints

### Phase 4: 3D Viewer (Week 7-8)
- [ ] Build Three.js viewer
- [ ] Add export functionality
- [ ] Integrate Vision Pro support
- [ ] Add sharing features

### Phase 5: Polish & Launch (Week 9-10)
- [ ] UI/UX polish
- [ ] Performance optimization
- [ ] Testing on multiple devices
- [ ] App Store submission

---

## 💰 Cost Estimate

| Component | Cost |
|-----------|------|
| **iOS Development** | $5,000 - $10,000 |
| **Cloud Infrastructure** | $100 - $500/month |
| **Domain/SSL** | $50/year |
| **App Store Fee** | $99/year |
| **Total (Year 1)** | $6,000 - $15,000 |

**Revenue Model:**
- Free tier: Basic stitching, watermarked
- Pro tier ($9.99): No watermark, HD export
- Business tier ($49.99): API access, custom branding

---

## 📝 Key Decisions

1. **Hybrid approach** selected for best quality + speed
2. **iOS first** (Teleport proven market, Vision Pro advantage)
3. **OpenPano** for core stitching (MIT license, well-maintained)
4. **SwiftUI-LiDAR** for capture + preview (modern, active)
5. **FastAPI** for cloud (Python ecosystem, easy deployment)
6. **Three.js** for web viewer (cross-platform, well-documented)

---

## 🔗 Resources

- **Teleport 360 Camera:** https://apps.apple.com/ca/app/teleport-360-camera/id6476905405
- **HDReye Website:** https://www.hdreye.app/teleport360
- **OpenPano:** https://github.com/ppwwyyxx/OpenPano
- **SwiftUI-LiDAR:** https://github.com/cedanmisquith/SwiftUI-LiDAR
- **PanoramaStitching:** https://github.com/fluidpixel/PanoramaStitching
- **360ls/stitcher:** https://github.com/360ls/stitcher

---

**Last Updated:** 2026-04-25
**Status:** Research Complete - Ready for Development
