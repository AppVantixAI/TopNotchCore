# TopNotch Core

A minimalist Dynamic Island implementation for macOS, bringing the iPhone's interactive notch experience to your Mac.

<div align="center">
  
  ![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
  ![macOS](https://img.shields.io/badge/macOS-14.0+-blue.svg)
  ![License](https://img.shields.io/badge/License-MIT-green.svg)
  
</div>

## Overview

TopNotch Core is a lightweight macOS application that creates an interactive notch at the top of your screen, similar to the Dynamic Island on iPhone 14 Pro and later models. It provides a clean, minimalist interface that can be expanded to show information and collapsed to stay out of your way.

## Features

- 🎯 **Native macOS App**: Built with SwiftUI for optimal performance
- 🎨 **Smooth Animations**: Fluid spring animations for all interactions
- 🖱️ **Click to Toggle**: Simple click to open/close the notch
- 📦 **Drag & Drop Ready**: Drop files onto the notch to trigger opening
- 🌓 **Dark Mode**: Seamlessly integrates with macOS appearance
- 🪶 **Lightweight**: Minimal resource usage with no background processes
- 🔒 **Privacy First**: No data collection, no network requests

## Current Implementation

### Core Components

1. **NotchView.swift**
   - Main view component handling the notch display
   - Smooth animations between closed/opened states
   - Hover detection and drag & drop support

2. **NotchViewModel.swift**
   - State management for the notch
   - Handles opening/closing logic
   - Manages screen geometry calculations

3. **NotchWindowController.swift**
   - Window management for borderless overlay
   - Positions window at screen top
   - Handles window level and behavior

4. **TopNotchCoreApp.swift**
   - Main app entry point
   - Hides dock icon for seamless experience
   - Manages app lifecycle

### Technical Details

- **Window Level**: Screen saver + 1 (stays above most windows)
- **Collection Behavior**: Can join all spaces, stationary
- **Notch Size (Closed)**: Approximates MacBook notch dimensions
- **Notch Size (Opened)**: 500 x 120 points
- **Animation**: Spring animation with 0.5s duration

## Installation

### Requirements
- macOS 14.0 or later
- Xcode 15.0 or later (for building from source)

### Building from Source

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/TopNotchCore.git
   cd TopNotchCore
   ```

2. Open in Xcode
   ```bash
   open TopNotchCore.xcworkspace
   ```

3. Build and run (⌘R)

## Usage

1. **Launch**: The app runs in the background with no dock icon
2. **Open/Close**: Click on the notch area at the top of your screen
3. **Drag & Drop**: Drag files to the notch area to automatically open it
4. **Close**: Click the X button or click outside the expanded notch

## Roadmap

- [ ] Preferences window for customization
- [ ] Widget system for displaying information
- [ ] Keyboard shortcuts
- [ ] Multi-monitor support
- [ ] Custom animations and effects
- [ ] Plugin architecture
- [ ] System integration (notifications, media controls)

## Architecture

```
TopNotchCore/
├── TopNotchCoreApp.swift    # App entry point
├── NotchView.swift          # Main UI component
├── NotchViewModel.swift     # State management
├── NotchWindowController.swift # Window management
└── Info.plist              # App configuration
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by Apple's Dynamic Island on iPhone
- Built with SwiftUI and the latest macOS technologies

---

<div align="center">
  Made with ❤️ for the Mac community
</div>
