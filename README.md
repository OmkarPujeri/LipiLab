# Lipi Lab: The Art of Devanagari

Lipi Lab is an educational iOS application designed to help users master the Devanagari script through interactive tracing and progressive learning paths. Built with SwiftUI and PencilKit, it offers a tactile and visual journey into the world of Hindi characters and words.

## Features

- **Progressive Learning Path**: Choose between learning individual letters (**Varnamala**) or full words (**Shabd Path**).
- **Comprehensive Library**: Includes Vowels (Swar), Consonants (Vyanjan), and Compound characters (Samyukta).
- **Interactive Tracing**: High-fidelity tracing interface using PencilKit with adjustable pen thickness.
- **Smart Validation**: Real-time outline matching engine to provide feedback on tracing accuracy.
- **Pencil Overlay**: A guided pencil animation to help beginners understand stroke order and direction.
- **Mastery Tracking**: A three-tier star system to track progress and mastery for every letter and word.
- **Bilingual Context**: Every character and word includes pronunciation guides, transliterations, and English meanings.

## Technical Details

- **Platform**: iOS 16.0+
- **Framework**: SwiftUI
- **Language**: Swift 6.0
- **Tools**: PencilKit for drawing, Vision for text recognition foundation, and Haptic feedback for interaction.
- **Project Format**: Swift Playgrounds App (.swiftpm)

## Project Structure

- `App.swift`: Main entry point.
- `ContentView.swift`: Navigation and state management for the entire app experience.
- `TracingView.swift` & `WordTracingView.swift`: The core tracing engines.
- `TracingMatcher.swift` & `OutlineMask.swift`: The logic behind validating user drawings against target characters.
- `LessonData.swift`: The data layer containing all Devanagari characters, words, and metadata.
- `MasteryManager.swift`: Handles persistent storage of user progress using `UserDefaults`.
- `DrawingCanvas.swift`: A `UIViewRepresentable` wrapper for `PKCanvasView`.

## Getting Started

1. Open `LipiLab.swiftpm` in **Xcode** (14.0+) or **Swift Playgrounds** on iPad/Mac.
2. Select an iOS 16.0+ simulator or a physical device.
3. Build and Run.

## Credits

Created as an educational tool for learning Devanagari script.

---
*Developed with ❤️ for Devanagari learners.*
