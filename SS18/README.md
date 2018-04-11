# FSIOS im SS 18

- [Vorlesung](#vorlesung)
  - [Inhaltsverzeichnis](#inhaltsverzeichnis)
  - [Assignments](#assignments)
- [Abschlussprojekt](#abschlussprojekt)
  - [Abschlusspräsentation](#abschlusspräsentation)
  - [Bewertungsgrundlage](#bewertungsgrundlage)
  - [Learning Outcomes](#learning-outcomes)

## Vorlesung 

### Inhaltsverzeichnis
| Datum  | Themen |
| ------------- | ------------- |
| 11.04.18 um 13 Uhr | - KickOff, Einleitung und Organisatorisches <br /> - [Demo](https://github.com/alexdobry/FSIOS/tree/master/SS18/01_introduction/demo/FlippingCard) und [Assignment](https://github.com/alexdobry/FSIOS/tree/master/SS18/01_introduction/your%20assignment) für `FlippingCard` |

*\* Steht noch nicht fest*

### Assignments
| Assignment | Eingereicht |
| ------------- | ------------- |
| 1 | TBA |

## Abschlussprojekt
Das Abschlussprojekt soll in einem Fork [dieses Projektes](https://github.com/alexdobry/FSIOS) liegen. Hierbei könnt ihr den gleichen Fork wie für die Assignments verwenden. Verwendet Tools wie Issues, Pull-Requests und Reviews, um euer Projekt auf GitHub zu managen.

Ein Kriterium für das Projekt ist wahlweise
- die Implementierung und/oder Anbindung eines Backends,
- die Implementierung einer [Extension](https://github.com/alexdobry/FSIOS/blob/master/WS17_18/12_framework_todaywidget/fsios_framework_todaywidget.pdf) und/oder,
- die Verwendung eines ausgewählten Core-Frameworks (CoreData, CoreLocation, CoreGraphics, etc...)

Dabei ist es wichtig, dass ihr eine größere Komponente in eurer App verwendet, die nicht in der Vorlesung thematisiert wurde. Beispiele hierfür sind
- CoreData oder SQLite
- Remote-Notifications (APNS)
- CollectionView- oder PageViewController

Ansonsten habt ihr alle Freiheiten.

| Team | Projekt |
| ------------- | ------------- |
| Alexander Dobrynin | [FSIOS](https://github.com/alexdobry/FSIOS) |

### Dokumentation 
Neben dem Code soll auch eine kleine Projektdokumentation auf Github zur Verfügung stehen. Hierfür könnt ihr die Readme.md als Landing-Page verwenden und eine Art *Getting-Started* aufsetzen. Alternativ könnt ihr das Wiki eines jeden Github-Projektes verwenden. Die Dokumentation soll einen *Überblick* über eure App geben. Sprich, welche Komponenten (nicht unbedingt Klassen) existieren, was sind die wichtigsten Komponenten und wie Kommunizieren diese miteinander. Das Ganze soll sowohl Prosa als auch Skizzen/Grafiken enthalten. Zudem könnt (und sollt) ihr diese Grafiken für eure Abschlusspräsentation wiederverwenden, um über die Architektur zu reden. **Begründet eure Entscheidungen** und betont zu euren Gunsten die ausschlaggebendsten Eigenschaften eurer App. Eine Strunktur kann bswp. folgendermaßen aussehen:

- Thema, Umfang, Motivation und Ziel der App
- Design (optisch, UI)
- Architektur
- Spannende Aspekte und Besonderheiten
- Herausforderungen

Die Dokumentation ist als ausführlichere Variante der Abschlusspräsentation zu verstehen, damit ich eine Erinnerungshilfe habe. 

### Abschlusspräsentation
Die Abschlusspräsentation beinhaltet Folien und eine Live-Demo der App. Die Dauer soll 40 Minuten betragen. Achtet darauf, dass ihr eure **Entscheidungen begründet und sinnvoll abwägt**. Die Präsentation sollte mindestens die folgenden Punkte beinhalten: 
- Thema (Wer, Was, Warum, für Wen)
- Design (UI und Interaction-Design, Usability, User-Experience)
- Architektur
- Durchführung und Vorgehen (z.B. Aufteilung und Absprachen)
- Herausforderungen
- besondere Highlights

Des Weiteren könnt ihr der Präsentation alles hinzufügen, was Begeisterung entfacht oder euch super darstellen lässt.  

### Bewertungsgrundlage
Damit ihr einen Leitfaden habt, ist hier meine Bewertungsgrundlage:
- Erfüllungsgrad der [Learning-Outcomes](#learning-outcomes)
- Beteiligung an den [Assignments](#assignments)
- Beherrschen und Dekonstruieren von komplexen Problemen in lösbare Einheiten
- Qualität des Codes
  - "Spaghetti-Code" vs. sinnvolle Kapselung von Komponenten
  - Klassen-, Variablen- und Funktionsnamen
  - Datenkapselung, Schnittstellen zwischen Komponenten und Kommunikationsstrukturen
  - Eleganz von Implementierungen
  - ...
- Einhalten von iOS und [Swift Idiomen](https://github.com/alexdobry/FSIOS/blob/master/WS17_18/07_swift/fsios_swift.pdf)
  - High-Order-Functions vs. For- und While-Schleifen mit If-Abfragen
  - Verwendung von Structs, Klassen, Enums und Optionals
  - Verwendung von `didSet`, `get {}` und `set {}` bei Properties
  - Verbosität von Funktionen (Verwendung von internen und externen Parameternamen bei Funktionen)
  - ...
- Verständnis und korrekte Verwendung von iOS, Cocoa-Touch und Frameworks
  - Einhalten von MVC (keine Anwendungslogik im Controller)
  - Sinnvolle Verwendung des ViewController Lifecycles
  - Belastung des Main-UI-Threads
  - Berücksichtigung von Memory-Leaks
  - ...
- Angeeignetes Wissen, welches nicht in der Veranstaltung thematisiert wurde und sonstige Transferleistungen
- Gebrauchstaugliches und adäquates mobiles Design unter Berücksichtigung der [iOS Design-Guidelines](https://developer.apple.com/ios/human-interface-guidelines/overview/themes/)
- Alles in der Abschlusspräsentation, vor allem der rote Faden, die Qualität der Begründungen und eure persönlichen Gedanken
- Alles, was ansonsten begeistert
- Eure persönliche Entwicklung

### Learning Outcomes
- Probleme Analysieren und Dekonstruieren, Lösungen Konzipieren, Fertigen und Bewerten 
- Bestehende Konzepte der Informatik konsolidieren
- Neue Programmiersprache, Konzepte und Sprachfeatures
- Mobile (iOS-lastige) Patterns und Programmierstile
- Funktionale Denkweise
- Mobile Entwicklung im Allgemeinen
- iOS Entwicklung im Speziellen
- Zusammenspiel von Design und Implementierung 
- Zusammenspiel von Mobile- und Backend App 
- (Kollaboratives) Arbeiten mit Git und GitHub
- Agile Softwareentwicklung (in einem Team)
