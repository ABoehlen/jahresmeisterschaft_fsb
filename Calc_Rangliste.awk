function calc_rangliste(    anz, anz_teiln, a_res, b_res, i, logfile, n, now, pflicht, rang, total, uebersicht) {

#########################################################################################
#
# Calc_Rangliste V2.1.4  08.12.2019
#
# Autor: Adrian Boehlen
#
# Programm berechnet alle Daten fuer die Erstellung der Rangliste
# - das Gesamtresultat jedes Teilnehmers wird gemaess Reglement ermittelt und in
#   das neue Feld "total" geschrieben.
# - es wird geprueft, ob der Schuetze gemaess Reglement erfuellt hat und dieser 
#   Status ins neue Feld "erfuellt" geschrieben.
# - bei Stgw57/02- und Stagw-Schuetzen wird der Bonus/Malus gemaess Reglement berechnet
# - die Daten werden anschliessend sortiert und in die neue Tabelle "auswertung.csv"
#   geschrieben.
# - die Tabelle wird erneut eingelesen und pro Rang werden die Gutpunkte gemaess
#   Reglement ins neue Feld "gutpte" geschrieben. 
# - zusaetzlich wird das Textfile "uebersicht.txt" erzeugt, welches die Resultate
#   jedes Teilnehmers auflistet
#
#########################################################################################

########## Variablen initialisieren, Dateien vorbereiten und Formatierung definieren  ##########

logfile = strftime("%Y%m%d", systime()) ".log";
format = "\t%11s   |  %4d    |  %7.3f    |\n";
now = strftime("%a %b %d %H:%M:%S %Y", systime()); # Zeitstempel fuer Logfile
outfile = "auswertung.csv";
uebersicht = "uebersicht.txt";

########## Uebersichtstabelle anlegen ##########

printf("")                                                                                       > uebersicht;
print "Dieses File in OpenOffice laden"                                                          > uebersicht;
print "Die Schriftart \"Courier 10 Pitch\" und die Schriftgroesse \"8\" einstellen"              > uebersicht;
print "Pro A4-Seite haben dann 3 Tabellen Platz; bei den Seitenumbruechen entsprechend anpassen" > uebersicht;

########## DB-File in zweidimensionalen Array einlesen ##########

db_einlesen(dbfile);
anz_teiln = t - 1;                   # Anzahl Teilnehmer ableiten

########## Auswerten der Resultate ##########

print "\n...Resultate werden ausgewertet und sortiert...\n";

for (comb in teilnehmer) {
  split(comb, sep, SUBSEP);
  if (sep[1] == "schuetze") {
    # Nicht-Pflichtresultate in temporaeres Resultate-Array einlesen
    resultate["gr"] = teilnehmer["gr_p", sep[2]];
    resultate["mar"] = teilnehmer["mar_p", sep[2]];
    resultate["ews"] = teilnehmer["ews_p", sep[2]];
    resultate["mi"] = teilnehmer["mi_p", sep[2]];
    resultate["hv"] = teilnehmer["hv_p", sep[2]];
    resultate["bub"] = teilnehmer["bub_p", sep[2]];
    resultate["sek"] = teilnehmer["sek_p", sep[2]];
    resultate["st"] = teilnehmer["st_p", sep[2]];
    resultate["sch"] = teilnehmer["sch_p", sep[2]];
    resultate["kun"] = teilnehmer["kun_p", sep[2]];

    ########## Auswerten Kategorie A ##########

    ++anz; # Zaehlervariable
	
    if (teilnehmer["kategorie_j", sep[2]] == "a") {
      print "\n" now " - " teilnehmer["schuetze", sep[2]] ":" >> logfile;

      # Tabelle fuer Uebersichtsfile erzeugen
      print "\n\n------------------------------------------------------"                    > uebersicht;
      print "Resultate von " teilnehmer["schuetze", sep[2]]                                 > uebersicht;
      print "------------------------------------------------------"                        > uebersicht;
      print "\t  Schiessen   |  Punkte  |  Prozente   |"                                    > uebersicht;
      print "\t--------------|----------|-------------|"                                    > uebersicht;
      printf(format,"OP:", teilnehmer["op_r", sep[2]], teilnehmer["op_p", sep[2]])          > uebersicht;
      printf(format,"VFS:", teilnehmer["vfs_r", sep[2]], teilnehmer["vfs_p", sep[2]])       > uebersicht;
      printf(format,"FS:", teilnehmer["fs_r", sep[2]], teilnehmer["fs_p", sep[2]])          > uebersicht;
      printf(format,"Grauholz:", teilnehmer["gr_r", sep[2]], teilnehmer["gr_p", sep[2]])    > uebersicht;
      printf(format,"Maerz:", teilnehmer["mar_r", sep[2]], teilnehmer["mar_p", sep[2]])     > uebersicht;
      printf(format,"EWS:", teilnehmer["ews_r", sep[2]], teilnehmer["ews_p", sep[2]])       > uebersicht;
      printf(format,"Minger:", teilnehmer["mi_r", sep[2]], teilnehmer["mi_p", sep[2]])      > uebersicht;
      printf(format,"Off. Anl.:", teilnehmer["hv_r", sep[2]], teilnehmer["hv_p", sep[2]])   > uebersicht;
      printf(format,"Bubenberg:", teilnehmer["bub_r", sep[2]], teilnehmer["bub_p", sep[2]]) > uebersicht;
      printf(format,"Sektion:", teilnehmer["sek_r", sep[2]], teilnehmer["sek_p", sep[2]])   > uebersicht;
      printf(format,"Stand:", teilnehmer["st_r", sep[2]], teilnehmer["st_p", sep[2]])       > uebersicht;
      printf(format,"Schnell:", teilnehmer["sch_r", sep[2]], teilnehmer["sch_p", sep[2]])   > uebersicht;
      printf(format,"Kunst:", teilnehmer["kun_r", sep[2]], teilnehmer["kun_p", sep[2]])     > uebersicht;

      # Pflichtresultate addieren
      pflicht = teilnehmer["op_p", sep[2]] + teilnehmer["vfs_p", sep[2]] + teilnehmer["fs_p", sep[2]];
      print "\tOP:  " teilnehmer["op_p", sep[2]]  >> logfile;
      print "\tVFS: " teilnehmer["vfs_p", sep[2]] >> logfile;
      print "\tFS:  " teilnehmer["fs_p", sep[2]]  >> logfile;
      print "\nUebrige beste Resultate:"          >> logfile;
      n = asort(resultate);
      for (i = n; i >= n-5; i--) {                      # die besten weiteren 6 Resultate
        a_res = a_res + resultate[i];
        print "\t" resultate[i]                   >> logfile;
      }

      # Pruefen, ob Pflicht- und genuegend Resultate vorliegen
      if (teilnehmer["op_p", sep[2]] > 0 && teilnehmer["vfs_p", sep[2]] > 0 && teilnehmer["fs_p", sep[2]] > 0 && teilnehmer["resultate", sep[2]] >= 9) {
        teilnehmer["erfuellt", sep[2]] = 1;             # Wert in neuem Feld "erfuellt" auf 1 setzen
        teilnehmer["total", sep[2]] = a_res + pflicht;  # Total in neues Feld schreiben

        # Bonus und Malus berechnen
        if (teilnehmer["waffe", sep[2]] == 2) {
          teilnehmer["total", sep[2]] = teilnehmer["total", sep[2]] + bonus_malus["A"];
          print "\t--------------|----------|-------------|" > uebersicht;
          printf(format,"Bonus:", "", bonus_malus["A"])      > uebersicht;
          print "\n\tBonus: " bonus_malus["A"]              >> logfile;
        }
        else if (teilnehmer["waffe", sep[2]] == 4) {
          teilnehmer["total", sep[2]] = teilnehmer["total", sep[2]] - bonus_malus["A"];
          print "\t--------------|----------|-------------|" > uebersicht;
          printf(format,"Malus:", "", bonus_malus["A"])      > uebersicht;
          print "\n\tMalus: " bonus_malus["A"]              >> logfile;
        }
        total[anz] = teilnehmer["total", sep[2]];       # Total auch in separates Total-Array schreiben
        print "\n\tGesamtresultat: " teilnehmer["total", sep[2]] "\n" >> logfile;

        # Resultat in Uebersichtstabelle eintragen
        print "\t========================================"                                  > uebersicht;
        printf("\t  Resultat:                %8.3f\n",teilnehmer["total", sep[2]])          > uebersicht;
        print "\t========================================"                                  > uebersicht;
      }
      else {
        teilnehmer["erfuellt", sep[2]] = 0;             # Wert in neuem Feld "erfuellt" auf 0 setzen
        teilnehmer["total", sep[2]] = a_res + pflicht;  # Total in neues Feld schreiben
        total[anz] = teilnehmer["total", sep[2]];       # Total auch in separates Total-Array schreiben
        print "\n\tGesamtresultat: zuwenig Resultate\n"               >> logfile;
        print "\n\tGesamtresultat: " teilnehmer["total", sep[2]] "\n" >> logfile;

        # Resultat in Uebersichtstabelle eintragen
        print "\t========================================"                                  > uebersicht;
        print "\t  Resultat:       Zuwenig Resultate"                                       > uebersicht;
        print "\t========================================"                                  > uebersicht;
      }

      a_res = 0;
    }

    ########## Auswerten Kategorie B ##########

    if (teilnehmer["kategorie_j", sep[2]] == "b") {
      print "\n" now " - " teilnehmer["schuetze", sep[2]] ":" >> logfile;

      # Tabelle fuer Uebersichtsfile erzeugen
      print "\n\n------------------------------------------------------"                    > uebersicht;
      print "Resultate von " teilnehmer["schuetze", sep[2]]                                 > uebersicht;
      print "------------------------------------------------------"                        > uebersicht;
      print "\t  Schiessen   |  Punkte  |  Prozente   |"                                    > uebersicht;
      print "\t--------------|----------|-------------|"                                    > uebersicht;
      printf(format,"OP:", teilnehmer["op_r", sep[2]], teilnehmer["op_p", sep[2]])          > uebersicht;
      printf(format,"VFS:", teilnehmer["vfs_r", sep[2]], teilnehmer["vfs_p", sep[2]])       > uebersicht;
      printf(format,"FS:", teilnehmer["fs_r", sep[2]], teilnehmer["fs_p", sep[2]])          > uebersicht;
      printf(format,"Grauholz:", teilnehmer["gr_r", sep[2]], teilnehmer["gr_p", sep[2]])    > uebersicht;
      printf(format,"Maerz:", teilnehmer["mar_r", sep[2]], teilnehmer["mar_p", sep[2]])     > uebersicht;
      printf(format,"EWS:", teilnehmer["ews_r", sep[2]], teilnehmer["ews_p", sep[2]])       > uebersicht;
      printf(format,"Minger:", teilnehmer["mi_r", sep[2]], teilnehmer["mi_p", sep[2]])      > uebersicht;
      printf(format,"Off. Anl.:", teilnehmer["hv_r", sep[2]], teilnehmer["hv_p", sep[2]])   > uebersicht;
      printf(format,"Bubenberg:", teilnehmer["bub_r", sep[2]], teilnehmer["bub_p", sep[2]]) > uebersicht;
      printf(format,"Sektion:", teilnehmer["sek_r", sep[2]], teilnehmer["sek_p", sep[2]])   > uebersicht;
      printf(format,"Stand:", teilnehmer["st_r", sep[2]], teilnehmer["st_p", sep[2]])       > uebersicht;
      printf(format,"Schnell:", teilnehmer["sch_r", sep[2]], teilnehmer["sch_p", sep[2]])   > uebersicht;
      printf(format,"Kunst:", teilnehmer["kun_r", sep[2]], teilnehmer["kun_p", sep[2]])     > uebersicht;

      resultate["vfs"] = teilnehmer["vfs_p", sep[2]];   # Vorueben Feldschiessen ergaenzen (nicht Pflicht in B)
      pflicht = teilnehmer["op_p", sep[2]] + teilnehmer["fs_p", sep[2]]; # Pflichtresultate addieren
      print "\tOP:  " teilnehmer["op_p", sep[2]]  >> logfile;
      print "\tFS:  " teilnehmer["fs_p", sep[2]]  >> logfile;
      print "\nUebrige beste Resultate:"          >> logfile;
      n = asort(resultate);
      for (i = n; i >= n-3; i--) {                      # die besten weiteren 4 Resultate
        b_res = b_res + resultate[i];
        print "\t" resultate[i]                   >> logfile;
      }

      # Pruefen, ob Pflicht- und genuegend Resultate vorliegen
      if (teilnehmer["op_p", sep[2]] > 0 && teilnehmer["fs_p", sep[2]] > 0 && teilnehmer["resultate", sep[2]] >= 6) {
        teilnehmer["erfuellt", sep[2]] = 1;             # Wert in neuem Feld "erfuellt" auf 1 setzen
        teilnehmer["total", sep[2]] = b_res + pflicht;  # Total in neues Feld schreiben

        # Bonus und Malus berechnen
        if (teilnehmer["waffe", sep[2]] == 2) {
          teilnehmer["total", sep[2]] = teilnehmer["total", sep[2]] + bonus_malus["B"];
          print "\t--------------|----------|-------------|" > uebersicht;
          printf(format,"Bonus:", "", bonus_malus["B"])      > uebersicht;
          print "\n\tBonus: " bonus_malus["B"]              >> logfile;
        }
        else if (teilnehmer["waffe", sep[2]] == 4) {
          teilnehmer["total", sep[2]] = teilnehmer["total", sep[2]] - bonus_malus["B"];
          print "\t--------------|----------|-------------|" > uebersicht;
          printf(format,"Malus:", "", bonus_malus["B"])      > uebersicht;
          print "\n\tMalus: " bonus_malus["B"]              >> logfile;
        }
        total[anz] = teilnehmer["total", sep[2]];       # Total auch in separates Total-Array schreiben
        print "\n\tGesamtresultat: " teilnehmer["total", sep[2]] "\n" >> logfile;

        # Resultat in Uebersichtstabelle eintragen
        print "\t========================================"                                  > uebersicht;
        printf("\t  Resultat:                %8.3f\n",teilnehmer["total", sep[2]])          > uebersicht;
        print "\t========================================"                                  > uebersicht;

      }
      else {
        teilnehmer["erfuellt", sep[2]] = 0;             # Wert in neuem Feld "erfuellt" auf 0 setzen
        teilnehmer["total", sep[2]] = b_res + pflicht;  # Total in neues Feld schreiben
        total[anz] = teilnehmer["total", sep[2]];       # Total auch in separates Total-Array schreiben
        print "\n\tGesamtresultat: zuwenig Resultate\n" >> logfile;

        # Resultat in Uebersichtstabelle eintragen
        print "\t========================================"                                  > uebersicht;
        print "\t  Resultat:       Zuwenig Resultate"                                       > uebersicht;
        print "\t========================================"                                  > uebersicht;

      }

      b_res = 0;
    }
    delete resultate;                                   # Resultate-Array wieder loeschen
  }
}
close(logfile);
close(uebersicht);

########## Daten in Output-File schreiben ##########

printf("")                     > outfile;                           # Output-File anlegen 

# Feldbezeichnungen schreiben

fields[f+1] = "total";                                              # neues Feld "total" anfuegen
fields[f+2] = "erfuellt";                                           # neues Feld "erfuellt" anfuegen
asort(fields);                                                      # Feldbezeichnungen sortieren
for (f = 1; f <= length(fields); f++) {
  if (f < length(fields))
    printf("%s,", fields[f])  > outfile;                            # Feldbezeichnungen mit Komma trennen...
  else
    printf("%s", fields[f])   > outfile;                            # ...ausser bei der letzten
}
printf("\n")                  > outfile;                            # Zeilenumbruch am Ende einfuegen

# Daten sortieren und anfuegen

asort(total);                                                       # Total-Array absteigend sortieren und...
for (i = length(total); i >= 1; i--) {                              # ...absteigend durchgehen
  for (t = 1; t <= anz_teiln; t++) {                                # fuer jeden Teilnehmer
    for (f = 1; f <= length(fields); f++) {                         # fuer jedes Feld
      for (comb in teilnehmer) {                                    # fuer jeden kombinierten Index
        split(comb, sep, SUBSEP);                                   # Index aufsplitten
        if (sep[1] == fields[f] && sep[2] == t) {                   # Feldwerte in sortierter Reihenfolge nach Teilnehmer 
          if (total[i] == teilnehmer["total", sep[2]]) {            # wenn aktueller Wert mit Total uebereinstimmt:
            if (f < length(fields)) {
              printf("%s,", teilnehmer[sep[1], sep[2]]) > outfile;  # Feldbezeichnungen mit Komma trennen...
              if (sep[1] == "schuetze") 
                print "Datensatz von " teilnehmer["schuetze", sep[2]] " wird geschrieben...";
            }
            else
              printf("%s\n", teilnehmer[sep[1], sep[2]]) > outfile; # ...ausser bei der letzten
          }
        }
      }
    }
  }
}
close(outfile);

########## Gutpunkte ermitteln ##########

print "\n...Gutpunkte werden berechnet...\n";

# neue Tabelle erneut in zweidimensionalen Array einlesen

db_einlesen(outfile);

# Gutpunkte berechnen

for (t = 1; t <= anz_teiln; t++) {
  for (f = 1; f <= length(fields); f++) {
    for (comb in teilnehmer) {
      split(comb, sep, SUBSEP);
      if (sep[1] == fields[f] && sep[2] == t) {
        if (sep[1] == "schuetze") {
          print "Gutpunkte von " teilnehmer["schuetze", sep[2]] " werden berechnet...";
          if (teilnehmer["erfuellt", sep[2]] == 1) {                 # wenn Teilnehmer erfuellt:
            if (teilnehmer["kategorie_j", sep[2]] == "a") {          # Gutpunkte Kategorie A
              rang++;                                                # Zaehler fuer den Rang
              if (rang == 1)
                teilnehmer["gutpte", sep[2]] = gutpunkt["A1"];       # Gutpunkte den einzelnen Raengen zuweisen
              else if (rang == 2)
                teilnehmer["gutpte", sep[2]] = gutpunkt["A2"];
              else if (rang ~ /3|4/)
                teilnehmer["gutpte", sep[2]] = gutpunkt["A3"];
              else if (rang ~ /5|6|7/)
                teilnehmer["gutpte", sep[2]] = gutpunkt["A5"];
              else
                teilnehmer["gutpte", sep[2]] = gutpunkt["A9p"];
            }
            else
              teilnehmer["gutpte", sep[2]] = gutpunkt["B"];          # pro Rang in Kategorie B immer gleich viele Punkte 
          }
          else 
            teilnehmer["gutpte", sep[2]] = 0;                        # keine Gutpunkte wenn nicht erfuellt
        }
      }
    } 
  }
}

########## Daten in Output-File schreiben ##########

printf("")                     > outfile;                            # Output-File anlegen 

# Feldbezeichnungen schreiben

fields[f+1] = "gutpte";                                              # neues Feld "gutpte" anfuegen
asort(fields);                                                       # Feldbezeichnungen sortieren
for (f = 1; f <= length(fields); f++) {
  if (f < length(fields))
    printf("%s,", fields[f])  > outfile;                             # Feldbezeichnungen mit Komma trennen...
  else
    printf("%s", fields[f])   > outfile;                             # ...ausser bei der letzten
}
printf("\n")                  > outfile;                             # Zeilenumbruch am Ende einfuegen

# Daten anfuegen

for (t = 1; t <= anz_teiln; t++) {                                   # fuer jeden Teilnehmer
  for (f = 1; f <= length(fields); f++) {                            # fuer jedes Feld
    for (comb in teilnehmer) {                                       # fuer jeden kombinierten Index
      split(comb, sep, SUBSEP);                                      # Index aufsplitten
      if (sep[1] == fields[f] && sep[2] == t) {                      # Feldwerte in sortierter Reihenfolge nach Teilnehmer 
        if (f < length(fields))
          printf("%s,", teilnehmer[sep[1], sep[2]])  > outfile;      # Feldbezeichnungen mit Komma trennen...
        else
          printf("%s\n", teilnehmer[sep[1], sep[2]]) > outfile;      # ...ausser bei der letzten
      }
    }
  }
}
close(outfile);

print "\nAuswertungstabelle '" outfile "' wurde erfolgreich angelegt";

}

