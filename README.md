# FSIOS

Ich werde Folien und die Demos in die jeweiligen Verzeichnisse mit der Struktur `x_content` hochladen. Damit ihr auf dem Laufenden bleibt, sollt ihr das Repository `forken` und wöchentlich `pullen`.

## Projekt
In eurem Fork arbeitet ihr an eurem Projekt. Benutzt ruhig die README, das Wiki, die Issues, das Board und die Pull-Requests, um TODO's zu sammeln, euch abzustimmen und kollaborativ zu arbeiten. Git und GitHub werden euch dabei helfen.

## Xcode und GitHub
* Die Projekte sollten **nicht** mit einem Developer Profil signiert werden, damit diese frei gepulled und gepushed werden können. Hierfür
  * bei neuen Projekten das *Team* auf *None* setzen oder 
  * bei bestehenden Projekten unter *Targets* das Projekt auswählen und unter *Signing* das *Team* auf *None* setzen.
* Um ein paar nervige Merge Konflikte beim kollaborativen Arbeiten mit Git zu vermeiden, soll eine `.gitattributes` auf der gleichen Ebene wie `.gitignore` erstellt werden. Der Inhalt der Datei ist `*.pbxproj binary merge=union` ([siehe hier](http://stackoverflow.com/questions/2615378/how-to-use-git-properly-with-xcode)).
