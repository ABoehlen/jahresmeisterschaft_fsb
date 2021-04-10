function pdc_wertpunkte(    anf_jahr, anf_jahr_total, anz_schuetzen, ende_jahr_total,\
f, heute, jahr, neu, neu_total, pdcfile, s_header, s_text, wertpte_tbl) { 

#########################################################################################
#
# PDC_Wertpunkte V1.0.3  31.10.2018
#
# Autor: Adrian Boehlen
#
# Programm erzeugt die Wertpunktetabelle im gewohnten Look&Feel im PDC - Format
# Punktebezuege muessen manuell im PDC-File ergaenzt und die Summe angepasst werden
# Das PDC-File muss anschliessend mittels pdf_generator.awk in ein PDF konvertiert werden
# - Bedingung: Die Tabelle "wertpunkte_<Vorjahr>.csv" muss aktualisiert worden sein,
#   d.h. die Funktion <calc wert> muss durchgelaufen sein
# - Die Summe des Punktestandes Anfang Jahr, der neuen Punkte und des 
#   Punktestandes Ende Jahr wird berechnet
# - Die durch <calc wert> erweiterte Tabelle "wertpunkte_<Vorjahr>.csv"
#   wird am Schluss wieder in ihren urspruenglichen Zustand zurueckversetzt
# 
#########################################################################################

########## Variablen initialisieren, Dateien vorbereiten und Feldseparator definieren ##########

FS = ",";
heute = strftime("%d.%m.%Y", systime());

do {
  printf("\nJahr der Meisterschaft eingeben: ");
  getline jahr;
} while (jahr ~ /^$/ || jahr < 2010 || jahr > 2030);

pdcfile = "wertpunkte_" jahr ".pdc";

do {
  printf("Wertpunktetabelle des Vorjahres angeben: ");
  getline wertpte_tbl;
} while (wertpte_tbl ~ /^$/);

if ((getline < wertpte_tbl) == -1) {
  print "\nTabelle " wertpte_tbl " existiert nicht";
  print "Bitte Funktion neu starten und korrekte Tabelle angeben";
  print "\n...Abbruch...\n";
  return;
}
else
  close(wertpte_tbl);

########## Wertpunktetabelle in zweidimensionalen Array einlesen ##########

t = 0;                               # Teilnehmerzaehler mit 0 initialisieren
while ((getline < wertpte_tbl) > 0) {
  if (NF != 3) {
    print "\nDie Struktur der Tabelle " wertpte_tbl " ist nicht korrekt";
    print "Bitte Struktur ueberpruefen und \"calc wert\" durchfuehren";
    print "\n...Abbruch...\n";
    close(wertpte_tbl);
    return;
  }
  else if (t == 0) {                 # Feldbezeichnungen in 1. Zeile einlesen
    for (f = 1; f <= NF; f++)
      fields[f] = $f;                # Feldbezeichnungen in Array einlesen
  }
  else {                             # Datenzeilen einlesen
    for (f = 1; f <= NF; f++)
      wertpunkte[fields[f], t] = $f; # zweidimensionaler Array aufbauen
  }
  t++;
}
close(wertpte_tbl);

anz_schuetzen = t - 1;               # Anzahl Teilnehmer ableiten

########## PDC-Datei aufbauen ##########

s_header = 8; # Schriftgroesse fuer Kopf- und Fusszeile
s_text =  12; # Schriftgroesse fuer normalen Text

# Header und Metadaten

print "filename wertpunkte_" jahr ".pdf"                                 > pdcfile;
print "author Adrian Böhlen"                                             > pdcfile;
print "title Wertpunktestand Ende " jahr                                 > pdcfile;
print "subject Jahresmeisterschaft"                                      > pdcfile;
print "page_size 210 297"                                                > pdcfile;
print "font Helvetica F1"                                                > pdcfile;
print "font Helvetica-Bold F2"                                           > pdcfile;
print "text F1 " s_header " 6 287 Jahresmeisterschaft FS Bolligen"       > pdcfile;
print "text F1 " s_header " 165 287 Wertpunktestand Ende " jahr          > pdcfile;
print "text F1 " s_header " 6 8 wertpunkte_" jahr ".pdc"                 > pdcfile;
print "text F1 " s_header " 92 8 Adrian Böhlen"                          > pdcfile;
print "text F1 " s_header " 190 8 " heute                                > pdcfile;

# Titel

print "text F1 22 55 261 Wertpunktestand Ende " jahr                     > pdcfile;
print "line 0.3 20 245 190 245"                                          > pdcfile;
print "line 0.3 20 245 20 230"                                           > pdcfile;
print "line 0.3 86 245 86 230"                                           > pdcfile;
print "line 0.3 112 245 112 230"                                         > pdcfile;
print "line 0.3 138 245 138 230"                                         > pdcfile;
print "line 0.3 164 245 164 230"                                         > pdcfile;
print "line 0.3 190 245 190 230"                                         > pdcfile;
print "text F2 " s_text " 23 236 Name"                                   > pdcfile;
print "text F2 " s_text " 89 236 1.1." jahr                              > pdcfile;
print "text F2 " s_text " 115 238 " jahr                                 > pdcfile;
print "text F2 " s_text " 115 233 bezogen"                               > pdcfile;
print "text F2 " s_text " 141 236 " jahr                                 > pdcfile;
print "text F2 " s_text " 167 238 Total"                                 > pdcfile;
print "text F2 " s_text " 167 233 Ende " jahr                            > pdcfile;


# Daten berechnen und in Ausgabefile schreiben

vpos = 225;   # vertikale Position des ersten Eintrages
abst = 7;     # Zeilenabstand

for (t = 1; t <= anz_schuetzen; t++) {            # fuer jeden Teilnehmer
  for (f = 1; f <= length(fields); f++) {         # fuer jedes Feld
    for (comb in wertpunkte) {                    # fuer jeden kombinierten Index
      split(comb, sep, SUBSEP);                   # Index aufsplitten
      if (sep[1] == fields[f] && sep[2] == t) {   # Feldwerte in sortierter Reihenfolge nach Teilnehmer 
        if (f == 1) {
          # Name
          print "text F1 " s_text " 23 " vpos " " wertpunkte[sep[1], sep[2]]  > pdcfile;
          print "Wertpunkte von " wertpunkte["schuetze", sep[2]] " werden geschrieben...";
        }
        else if (f == 2) {
          # Wertpunkte Anfang Jahr
          print "text F1 " s_text " 89 " vpos " " wertpunkte[sep[1], sep[2]]  > pdcfile;
          anf_jahr = wertpunkte[sep[1], sep[2]];
          anf_jahr_total = anf_jahr_total + anf_jahr;
        }
        else if (f == 3) {
          # Wertpunkte bezogen und neu aus Jahresmeisterschaft
          print "text F1 " s_text " 115 " vpos " 0" > pdcfile;
          print "text F1 " s_text " 141 " vpos " " wertpunkte[sep[1], sep[2]] > pdcfile;
          neu = wertpunkte[sep[1], sep[2]];
          neu_total = neu_total + neu;

          # Wertpunkte Ende Jahr
          print "text F1 " s_text " 167 " vpos " " (anf_jahr + neu)           > pdcfile;
          ende_jahr_total = ende_jahr_total + anf_jahr + neu;

          # Linien erzeugen
          print "line 0.3 20 " (vpos + 5) " 190 " (vpos + 5)                  > pdcfile;
          print "line 0.3 20 " (vpos + 5) " 20 " (vpos - 2)                   > pdcfile;
          print "line 0.3 86 " (vpos + 5) " 86 " (vpos - 2)                   > pdcfile;
          print "line 0.3 112 " (vpos + 5) " 112 " (vpos - 2)                 > pdcfile;
          print "line 0.3 138 " (vpos + 5) " 138 " (vpos - 2)                 > pdcfile;
          print "line 0.3 164 " (vpos + 5) " 164 " (vpos - 2)                 > pdcfile;
          print "line 0.3 190 " (vpos + 5) " 190 " (vpos - 2)                 > pdcfile;

         # Vertikale Position um abst reduzieren
          vpos = vpos - abst;
        }
      }
    }
  }
}

# Summen ausgeben
print "# Summen"                                               > pdcfile;
print "text F2 " s_text " 89 " vpos " " anf_jahr_total         > pdcfile;
print "text F2 " s_text " 115 " vpos " " 0                     > pdcfile;
print "text F2 " s_text " 141 " vpos " " neu_total             > pdcfile;
print "text F2 " s_text " 167 " vpos " " ende_jahr_total       > pdcfile;

# Linien letzte Zeile
print "line 0.3 20 " (vpos + 5) " 190 " (vpos + 5)             > pdcfile;
print "line 0.3 20 " (vpos + 5) " 20 " (vpos - 2)              > pdcfile;
print "line 0.3 86 " (vpos + 5) " 86 " (vpos - 2)              > pdcfile;
print "line 0.3 112 " (vpos + 5) " 112 " (vpos - 2)            > pdcfile;
print "line 0.3 138 " (vpos + 5) " 138 " (vpos - 2)            > pdcfile;
print "line 0.3 164 " (vpos + 5) " 164 " (vpos - 2)            > pdcfile;
print "line 0.3 190 " (vpos + 5) " 190 " (vpos - 2)            > pdcfile;
print "line 0.3 20 " (vpos - 2) " 190 " (vpos - 2)             > pdcfile;

# Tabelle "wertpunkte_<Vorjahr>.csv" in urspruenglichen Zustand zuruecksetzen

printf("")                                             > wertpte_tbl;
printf("schuetze,%d\n", jahr - 1)                      > wertpte_tbl;
for (t = 1; t <= anz_schuetzen; t++) {
  for (f = 1; f <= length(fields); f++) {
    for (comb in wertpunkte) {
      split(comb, sep, SUBSEP);
      if (sep[1] == fields[f] && sep[2] == t) {
        if (f == 1) {
          # Name
          printf("%s,", wertpunkte[sep[1], sep[2]])    > wertpte_tbl;
        }
        else if (f == 2) {
          # Wertpunkte Vorjahr
          printf("%s\n", wertpunkte[sep[1], sep[2]])   > wertpte_tbl;
        }
      }
    }
  }
}

close(wertpte_tbl);
close(pdcfile);

}
