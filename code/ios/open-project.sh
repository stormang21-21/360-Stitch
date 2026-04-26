#!/bin/bash
# Open 360Stitch project in Xcode

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_FILE="$PROJECT_DIR/360Stitch.xcodeproj"

if [ -d "$PROJECT_FILE" ]; then
    echo "Opening 360Stitch project..."
    open "$PROJECT_FILE"
    echo ""
    echo "Project opened in Xcode!"
    echo ""
    echo "Next steps:"
    echo "1. Wait for OpenCV package to download (1-2 minutes)"
    echo "2. Select your iPhone from the device dropdown"
    echo "3. Press Cmd+B to build"
    echo "4. Press Cmd+R to run on device"
    echo ""
    echo "If this is your first time:"
    echo "- Enable automatic signing in project settings"
    echo "- Select your Apple ID team"
    echo "- Trust the developer on your iPhone"
else
    echo "Error: Project file not found at $PROJECT_FILE"
    exit 1
fi
