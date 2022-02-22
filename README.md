# FSIOS

## Laufende Veranstaltung
[SS 22](https://github.com/alexdobry/FSIOS_SS22)

## Vergangene Veranstaltungen
- [SS 21](https://github.com/alexdobry/FSIOS_SS21)
- [SS 20](https://github.com/alexdobry/FSIOS_SS20)
- [WS 18/19](https://github.com/alexdobry/FSIOS_WS18-19)
- [SS 18](https://github.com/alexdobry/FSIOS_SS18)
- [WS 17/18](https://github.com/alexdobry/FSIOS_WS17-18)
- [SS 17](https://github.com/alexdobry/FSIOS_SS17)

## Empfohlene Voraussetzungen
- Englisch, da Screencasts und Literatur auf Englisch sind
- Fortgeschrittene Programmierkenntnisse, egal in welcher Sprache
- Leider wird ein Mac vorausgesetzt, weil man nur auf einem Mac für iOS entwickeln kann

## Kurzbeschreibung
In dieser Veranstaltung lernen wir, wie man Apps für iOS mit Swift und SwiftUI entwickelt. Dabei lernen wir sowohl eine neue Programmiersprache (Swift), als auch ein neues Ökosystem (iOS) kennen. Zudem verwenden wir für die UI Entwicklung das neue deklarative UI-Framework namens SwiftUI. 

Eine klassische Vorlesung wird es nicht geben. Die Veranstaltung orientiert sich an dem Kurs [Developing Applications for iOS using SwiftUI (CS193p)](https://cs193p.sites.stanford.edu) der Stanford University. Wir schauen uns die Videos von CS193p an und diskutieren die Inhalte in einem wöchentlichen Meeting. Zudem werden wir auch deren Aufgaben machen, um uns direkt mit dem tatsächlichen Entwickeln von Apps vertraut zu machen.

Als Abschlussprojekt entwickeln Sie eine eigene App. Dabei bauen Sie zum einen auf den gelernten Inhalten auf. Zum anderen müssen Sie sich ein Thema aussuchen (Technologie, Framework, API, etc.), dessen Inhalte Sie sich für das Projekt aneignen.

## Learning Outcomes
- Probleme Analysieren und Dekonstruieren, Lösungen Konzipieren, Fertigen und Bewerten
- Bestehende Konzepte der Informatik konsolidieren
- Neue Programmiersprache, Konzepte und Sprachfeatures
- Mobile (iOS-lastige) Patterns und Programmierstile
- Funktionale Denkweise
- Mobile Entwicklung im Allgemeinen
- iOS Entwicklung im Speziellen
- Zusammenspiel von Design und Implementierung

## Arbeitsaufwand
4 SWS, davon
- ~2 SWS Vorlesung
- ~2 SWS Projekt

Gesamtaufwand **180 Stunden**, davon
- 30% Vorlesung
- 30% Selbststudium
- 40% Projektarbeit

## Studien-/Prüfungsleistungen
Die Note setzt sich aus App und Fachvortrag zusammen.

## Literatur
- [Developing Applications for iOS using SwiftUI (CS193p)](https://cs193p.sites.stanford.edu)
- [Swift Programming Language Guide](https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html)
- [Swift Standard Library](https://developer.apple.com/documentation/swift/swift_standard_library)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/)
- [Introducing SwiftUI Tutorial von Apple](https://developer.apple.com/tutorials/swiftui)
- [Discover SwiftUI by John Sundell](https://www.swiftbysundell.com/discover/swiftui/)
- [Paul Hudsons YouTube Tutorials zu Swift, SwiftUI und co.](https://www.youtube.com/channel/UCmJi5RdDLgzvkl3Ly0DRMlQ)

## Inhalte
Die Liste ist nur eine grobe Vorschau, vom Semester abhängig und daher nicht vollständig.

### Mobile Computing
- Mobile constraints
    + Trafic
    + Performance
    + Single main thread
    + 25 FPS / frame drops
    + Secure connection (https only)
- Users privacy
    + Personal data
    + Trust
- Persistance
    - UserDefaults (Key-Value Storage)
    - Core Data (kinda object oriented SQLite)
    - File System
- Multithreading
    + main thread
    + background threads
- Networking
- Sensors
- Gestures
    + Touch
    + Pan
- Event driven programming
    + Application lifecycle
    + Background time / updates
- UI and Interaction Design
- Notifications
    + User Notfications
    + Silent Notifications
- Permissions and Entitlements
- Developer Programm
- App signing

### iOS Development
- Platform architecture
    + App <- Cocoa Touch <- Media <- Core Services <- Core OS
- Cocoa Touch vs. Swift vs. Swift UI
- Swift Programming Language
- Objective-C
- Swift is open source (swift evolution process)
- Memory management (automatic reference counting - ARC)
- Xcode
- Swift Playgrounds

### Architecture
- MVVM (Model-View-ViewModel)
- Declarative UI
- Reactive UI

### Swift Programming Language
- Swift Language Features
- Swift Type System
- Escaping and non-escaping closures
- Functional programming in Swift
- Protocol oriented programming in Swift

### UI Development
- Layout System
    - View Management
    - View lifecycle
    - Coordinate system
    - Points vs. Pixels
    - Geometry Reader
    - SwiftUIs adaption
- Navigation
- Creating custom views
- Drawing custom views
    - Shape
- Animations
- Swift UI
    - @ViewBuilder
    - View modifier
    - Property Observers
    - Property Wrappers
        + @State
        + @Published
        + @ObservedObject
- UIKit Integration
