# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BoxSys2 (JuBoxSys2) is an iOS dynamic UI rendering system that uses JSON templates and data to dynamically compose and display UI elements. The project has been fully migrated to Swift 5.

## Build Commands

```bash
# Build using Xcode
xcodebuild -project boxsys.xcodeproj -scheme boxsys -sdk iphonesimulator build

# Run on simulator
xcodebuild -project boxsys.xcodeproj -scheme boxsys -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15' build
```

## Architecture

### Core Components (JuBoxSys2/)

**JuBoxSys.swift** - Contains all core engine classes:

- **JuBoxExtend** - Enum defining scaling modes (none, width, height, both)
- **JuBoxSysDelegate** - Protocol for callbacks (getContainer, onBoxSysEvent)
- **JuBoxModel** - Base model class for template configuration
- **JuBox** - Base display element class
- **JuListRelativeBoxModel** / **JuListBoxModel** - List container models
- **JuListBox** - List container box
- **JuBoxCache** - Two-layer cache manager (key -> boxName -> Box)
- **JuBoxVersion** - Version validation utility
- **JuBoxSys2** - Singleton manager with static methods for initialization, model loading, and box rendering

**JuBoxExtensions.swift** - Extension box types:

- **JuButtonBox / JuButtonBoxModel** - Interactive button with image/URL support
- **JuArrayBox / JuArrayBoxModel** - Vertical sequential layout
- **JuGroupBox / JuGroupBoxModel** - Fixed position group layout with scaling

### Application Layer (boxsys/)

- **AppDelegate.swift** - App entry, initializes JuBoxSys2 and loads models from JuModel.json
- **ViewController.swift** - Demo view controller implementing JuBoxSysDelegate

### JSON Data Flow

1. **Model JSON** (`JuModel.json`) - Defines templates with type, dimensions, and nested block references
2. **Data JSON** (`JuToday.json`) - Provides actual content (images, URLs, tracking info)

## Key Patterns

- Box types are dynamically instantiated via `JuBoxSys2.generateBox(type:)` and `JuBoxSys2.generateModel(type:)` based on the `type` field in JSON
- Type registration: `JuBoxSys2.register(type:modelClass:boxClass:)` maps type strings to Swift classes
- The system supports proportional scaling via `JuBoxExtend` enum
- Thread safety via NSLock in JuBoxSys2

## Swift Migration Notes

- All classes use `required init()` for dynamic instantiation
- Weak references used for delegate to prevent retain cycles
- Uses native Swift JSON parsing via JSONSerialization
- Minimum deployment target: iOS 12.0
