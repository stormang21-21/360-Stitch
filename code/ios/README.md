# 360 Stitch - iOS Capture App

## Overview
SwiftUI app for guided 360° panorama capture with ARKit and CoreMotion.

## Features
- **ARKit Guided Capture**: Visual guidance for 360° rotation
- **Motion Tracking**: CoreMotion for precise angle tracking
- **Real-time Preview**: Live camera feed with overlay
- **Progress Tracking**: Visual progress bar and angle indicator
- **Image Capture**: Automatic capture at set intervals
- **Basic Stitching**: OpenCV integration for panorama creation

## Requirements
- iOS 16.0+
- Xcode 15.0+
- OpenCV framework (included via Swift Package Manager)
- ARKit compatible device

## Setup

### Quick Start
1. **Open Project**
   ```bash
   cd ~/Projects/360-Stitch/code/ios
   open 360Stitch.xcodeproj
   ```

2. **First Build**
   - Xcode will automatically resolve the OpenCV package
   - Wait for package download (takes 1-2 minutes)
   - Select your iPhone from the device dropdown
   - Press **Cmd+B** to build

3. **Configure Signing** (first time only)
   - Select project → Signing & Capabilities
   - Check "Automatically manage signing"
   - Select your Apple ID team
   - Update bundle identifier if needed: `sg.whatif.360stitch`

4. **Run on Device**
   - Connect iPhone via USB (or wireless if paired)
   - Trust computer on iPhone
   - Press **Cmd+R** or click ▶ Run

## Usage

1. **Launch App**: Grant camera and motion permissions
2. **Start Capture**: Tap the blue button
3. **Rotate Device**: Slowly rotate 360° following guidance
4. **Complete**: Progress bar shows completion
5. **Preview**: View captured images
6. **Stitch**: Process images into panorama

## Architecture

```
ContentView
├── CameraPreviewView (ARKit)
├── AROverlayView (Guidance)
├── CaptureManager (Logic)
│   ├── Motion Tracking
│   ├── Image Capture
│   └── Progress Management
└── StitchingService (OpenCV)
```

## Next Steps
- [ ] Test on physical device
- [ ] Add cloud stitching integration
- [ ] Implement advanced stitching algorithms
- [ ] Add 3D viewer for panoramas
- [ ] Add export options (OBJ, GLB, Equirectangular)
- [ ] Add Vision Pro support

## Notes
- Requires device with ARKit support (iPhone 6s+)
- Motion tracking requires gyroscope
- Camera quality affects stitching results
- Test with well-lit environments for best results
- OpenCV 4.9.0+ is automatically downloaded via SPM