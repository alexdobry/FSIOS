# FSIOS

Laufende Veranstaltung

- [WS 18/19](https://github.com/alexdobry/FSIOS_WS18-19)

Vergangene Veranstaltungen

- [SS18](https://github.com/alexdobry/FSIOS_SS18)
- [WS 17/18](https://github.com/alexdobry/FSIOS_WS17-18)
- [SS17](https://github.com/alexdobry/FSIOS_SS17)

## Vorlesung

In den Vorlesungen werden verschiedene Inhalte mobiler Entwicklung, insbesondere der iOS Entwicklung mit Swift, behandelt. Dabei werden viele Aspekte und Konzepte der Informatik theoretisch und praktisch angewendet.

Benotet wird ein durchzuführendes Projekt (2er Teams) und eine Abschlusspräsentation. Das Projekt ist frei zu wählen und beinhaltet die "Full Stack Entwicklung" einer iOS App mit Swift.

Das WPF kann wahlweise mit 6CP für die MPO4 oder mit 5CP für die MPO3 als WPF A oder B durchgeführt werden.

### Inhalt

Die Liste ist nur eine grobe Vorschau, vom Semester abhängig und daher nicht vollständig.

- Design und Implementierung einer iOS App mit Swift
- Mobile Entwicklung, iOS, Xcode und Tools
- Programmiersprache Swift, seine Konzepte und Patterns
- Objektorientierte Programmierung und angewandte funktionale Konzepte
- Verwenden von System-APIs und Third-Party-Bibliotheken
- Mobiler Network-Stack
- Mobile Storage Konzepte
- Multithreading und Event-Getriebene Denkweisen
- UI- und Interaction-Design, insbesondere im mobilen Kontext
- Verwenden eines Backend-Systems im mobilen Kontext
- Anwenden verschiedener Konzepte aus der Informatik
- Kollaboratives und agiles Arbeiten im Team
- Arbeiten, Dokumentieren und Organisieren mithilfe von Versionsverwaltungs-Tools

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
- Kollaborative Arbeiten mit Git und GitHub
- Agile Softwareentwicklung in einem Team

## Projekt

In eurem Fork arbeitet ihr an eurem Projekt. Benutzt ruhig die README, das Wiki, die Issues, das Board und die Pull-Requests, um TODO's zu sammeln, euch abzustimmen und kollaborativ zu arbeiten. Git und GitHub werden euch dabei helfen.

### Xcode und GitHub

* Die Projekte sollten **nicht** mit einem Developer Profil signiert werden, damit diese frei gepulled und gepushed werden können. Hierfür
  * bei neuen Projekten das *Team* auf *None* setzen oder 
  * bei bestehenden Projekten unter *Targets* das Projekt auswählen und unter *Signing* das *Team* auf *None* setzen.
* Um ein paar nervige Merge Konflikte beim kollaborativen Arbeiten mit Git zu vermeiden, soll eine `.gitattributes` auf der gleichen Ebene wie `.gitignore` erstellt werden. Der Inhalt der Datei ist `*.pbxproj binary merge=union` ([siehe hier](http://stackoverflow.com/questions/2615378/how-to-use-git-properly-with-xcode)).
