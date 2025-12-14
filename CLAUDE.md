# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

BoxSys2 (JuBoxSys2) is an iOS dynamic UI rendering system that uses JSON templates and data to dynamically compose and display UI elements. Originally created around 2014, the project was recently converted to ARC (Automatic Reference Counting).

## Build Commands

```bash
# Build using Xcode
xcodebuild -project boxsys.xcodeproj -scheme boxsys -sdk iphonesimulator build

# Build the JuBoxSys framework
xcodebuild -project boxsys.xcodeproj -scheme JuBoxSys -sdk iphonesimulator build

# Run tests
xcodebuild -project boxsys.xcodeproj -scheme boxsysTests -sdk iphonesimulator test
```

The project uses the `boxsys.xcodeproj` Xcode project with multiple targets:
- `boxsys` - Demo iOS application
- `JuBoxSys` - The framework/library
- `boxsysTests` - Unit tests

## Architecture

### Core Components (JuBoxSys2/Engine/)

- **JuBoxSys2** - Main entry point. Initialize with `initBoxSys:`, load models via `loadModel:`, and render with `loadBox:withKey:withData:width:height:withDelegate:`.

- **JuBoxModel** - Template configuration class. Defines layout structure with properties like `name`, `type`, `width`, `height`. Templates are loaded from JSON and cached.

- **JuBox** - Display element base class. Stores actual rendering data (`x`, `y`, `width`, `height`), a reference to its `JuBoxModel`, and generates `UIView` objects via `boxView` property.

- **JuListBox** - Container Box that holds a list of child boxes (`subBoxList`).

- **JuBoxCache** - Caches rendered Box instances by key.

- **JuBoxSysDelegate** - Protocol for callbacks. Provides `getContainer` (returns UIView container) and `onBoxSysEvent:withArgs:` (event handling).

### Extension Box Types (JuBoxSys2/Extension/)

- **JuGroupBox** - Groups multiple child boxes at fixed positions
- **JuArrayBox** - Arranges child boxes sequentially (vertical layout)
- **JuButtonBox** - Interactive button element with image/URL support

Each Box type has a corresponding Model class (e.g., `JuGroupBoxModel`, `JuButtonBoxModel`).

### JSON Data Flow

1. **Model JSON** (`JuModel.json`) - Defines templates with type, dimensions, and nested block references
2. **Data JSON** (`JuToday.json`) - Provides actual content (images, URLs, tracking info)

Templates reference other templates by name and use `map` to specify which data key to use.

## Dependencies

Uses SBJson framework (json-framework-3.2.0) for JSON parsing, linked as a static library (`libsbjson-ios.a`).

## Key Patterns

- Box types are dynamically instantiated via `generateBox:` and `generateModel:` based on the `type` field in JSON
- The system supports proportional scaling via `JuEBoxExtend` enum (ExtendWidth, ExtendHeight, etc.)
- Memory management uses `close` methods on Box/Model classes to break retain cycles (legacy from pre-ARC)
