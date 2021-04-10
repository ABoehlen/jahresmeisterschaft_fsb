function calc_wertpunkte(    anz_schuetzen, anz_teiln, combt, combw, ft, fw, i, jahr,\
lastyear, tt, tw, wertpte_tbl, wertpte_tbl_neu) { 

############################################################################################
#
# Calc_Wertpunkte V2.1.0  21.02.2018
#
# Autor: Adrian Boehlen
#
# Programm aktualisiert die Wertpunktetabelle
# - es wird geprueft, ob die Tabelle "auswertung.csv" vorhanden ist
# - die Wertpunktetabelle vom Vorjahr wird eingelesen. Diese muss genau 2 Felder enthalten:
#   - schutze, <Vorjahr> 
#   und folgenden Namen haben: "wertpunkte_<Vorjahr>.csv
# - durch die Berechnung wird ein neues Feld mit dem aktuellen Jahr angefuegt 
# - zum Schluss wird eine neue Wertpunktetabelle mit folgenden 2 Feldern erzeugt:
#   - schuetze, <akt. Jahr>
#   mit diesem Namen: "wertpunkte_<akt. Jahr>.csv
# 
############################################################################################

########## Variablen initialisieren, Dateien vorbereiten und Feldseparator definieren ##########

infile = "auswertung.csv";
FS = ",";

if ((getline < infile) == -1) {
  print "\nTabelle \"auswertung.csv\" existiert nicht";
  print "Die Funktion \"calc rang\" muss zuerst ausgefuehrt werden";
  print "\n...Abbruch...\n";
  return;
}
else
  close(infile);

do {
  printf("\nJahr der Meisterschaft eingeben: ");
  getline jahr;
} while (jahr ~ /^$/ || jahr < 2010 || jahr > 2030);

lastyear = jahr - 1;

# Name der bestehenden Wertpunktetabelle festlegen und einlesen
wertpte_tbl = "wertpunkte_" lastyear ".csv";

if ((getline < wertpte_tbl) == -1) {
  print "\nTabelle " wertpte_tbl " existiert nicht";
  print "Bitte Funktion neu starten und korrekte Tabelle angeben";
  print "\n...Abbruch...\n";
  return;
}
else
  close(wertpte_tbl);

########## Auswertungstabelle in zweidimensionalen Array einlesen ##########

tt = 0;                                  # Teilnehmerzaehler mit 0 initialisieren
while ((getline < infile) > 0) {
  if (tt == 0) {                         # Feldbezeichnungen in 1. Zeile einlesen
    for (ft = 1; ft <= NF; ft++)
      fieldst[ft] = $ft;                 # Feldbezeichnungen in Array einlesen
  }
  else {                                 # Datenzeilen einlesen
    for (ft = 1; ft <= NF; ft++)
      teilnehmer[fieldst[ft], tt] = $ft; # zweidimensionaler Array aufbauen
  }
  tt++;
}
close(infile);

anz_teiln = tt - 1;                      # Anzahl Teilnehmer ableiten

########## Wertpunktetabelle in zweidimensionalen Array einlesen ##########

tw = 0;                                  # Teilnehmerzaehler mit 0 initialisieren
while ((getline < wertpte_tbl) > 0) {
  if (tw == 0) {                         # Feldbezeichnungen in 1. Zeile einlesen
    for (fw = 1; fw <= NF; fw++)
      fieldsw[fw] = $fw;                 # Feldbezeichnungen in Array einlesen
  }
  else {                                 # Datenzeilen einlesen
    for (fw = 1; fw <= NF; fw++)
      wertpunkte[fieldsw[fw], tw] = $fw; # zweidimensionaler Array aufbauen
  }
  tw++;
}
close(wertpte_tbl);

anz_schuetzen = tw - 1;

########## Wertpunkte fuer das aktuelle Jahr aus Auswertungstabelle uebertragen ##########

# Teilnehmerliste gemaess aktueller Jahresmeisterschaft
i = 1;
for (combt in teilnehmer) {
  split (combt, sept, SUBSEP);
  if (sept[1] == "schuetze") {
    schuetzent[i] = teilnehmer["schuetze", sept[2]];
    i++;
  }
}
asort(schuetzent);

# Teilnehmerliste gemaess bisheriger Wertpunktetabelle
i = 1;
for (combw in wertpunkte) {
  split (combw, sepw, SUBSEP);
  if (sepw[1] == "schuetze") {
    schuetzenw[i] = wertpunkte["schuetze", sepw[2]];
    i++;
  }
}
asort(schuetzenw);

# bereits in Wertpunktetabelle enthaltene Schuetzen,
# die an der Jahresmeisterschaft teilgenommen haben

for (combw in wertpunkte) {
  split (combw, sepw, SUBSEP);
  if (sepw[1] == "schuetze") {
    for (combt in teilnehmer) {
      split (combt, sept, SUBSEP);
      if (sept[1] == "schuetze") {
        if (wertpunkte["schuetze", sepw[2]] == teilnehmer["schuetze", sept[2]]) {
          if (teilnehmer["erfuellt", sept[2]] == 1)
            wertpunkte[jahr, sepw[2]] = teilnehmer["gutpte", sept[2]] + teilnehmer["kraenze", sept[2]] * 2; 
          else
            wertpunkte[jahr, sepw[2]] = 0;
        }
      }
    }
  }
}

# bereits in Wertpunktetabelle enthaltene Schuetzen,
# die an der Jahresmeisterschaft nicht teilgenommen haben

for (combw in wertpunkte) {
  split (combw, sepw, SUBSEP);
  if (sepw[1] == "schuetze") {
    if (wertpunkte[jahr, sepw[2]] == "") {
      wertpunkte[jahr, sepw[2]] = 0;        # neue Punktzahl ueberall 0
    }
  }
}

########## noch nicht in der Wertpunktetabelle enthaltene Schuetzen, ##########
# die an der Jahresmeisterschaft teilgenommen haben

# tbd!!!

########## aktualisierte Daten wieder in wertpunktetabelle schreiben ##########

printf("")                     > wertpte_tbl;                            # Output-File anlegen 

# Feldbezeichnungen schreiben
fieldsw[fw+1] = jahr;                                                    # neues Feld mit aktuellem Jahr anfuegen
for (fw = 1; fw <= length(fieldsw); fw++) {
  if (fw < length(fieldsw))
    printf("%s,", fieldsw[fw]) > wertpte_tbl;                            # Feldbezeichnungen mit Komma trennen...
  else
    printf("%s", fieldsw[fw])  > wertpte_tbl;                            # ...ausser bei der letzten
}
printf("\n")                   > wertpte_tbl;                            # Zeilenumbruch am Ende einfuegen

# Daten anfuegen
for (tw = 1; tw <= anz_schuetzen; tw++) {                                # fuer jeden Teilnehmer
  for (fw = 1; fw <= length(fieldsw); fw++) {                            # fuer jedes Feld
    for (combw in wertpunkte) {                                          # fuer jeden kombinierten Index
      split(combw, sepw, SUBSEP);                                        # Index aufsplitten
      if (sepw[1] == fieldsw[fw] && sepw[2] == tw) {                     # Feldwerte in sortierter Reihenfolge nach Teilnehmer 
        if (fw < length(fieldsw))
          printf("%s,", wertpunkte[sepw[1], sepw[2]])   > wertpte_tbl;   # Feldbezeichnungen mit Komma trennen...
        else
          printf("%s\n", wertpunkte[sepw[1], sepw[2]])  > wertpte_tbl;   # ...ausser bei der letzten
      }
    }
  }
}
close(wertpte_tbl);

# neue Wertpunktetabelle ableiten

t = 0;
wertpte_tbl_neu = "wertpunkte_" jahr ".csv";
while ((getline < wertpte_tbl) > 0) {
  if (t == 0) 
    printf("%s, %d\n", $1, $3)        > wertpte_tbl_neu;
  else 
    printf("%s, %d\n", $1, $2 + $3)   > wertpte_tbl_neu;
  t++;
}
close(wertpte_tbl);
close(wertpte_tbl_neu);

print "\nneue Wertpunktetabelle " wertpte_tbl_neu " wurde geschrieben";

}

