function korrektur(    antwort, anz_teiln, bakfile, daten, exist, i, k, kranzanz, logfile, now, r, resanz, schiessen, schuetze) {

#########################################################################################
#
# Korrektur V2.1.3  17.11.2019
#
# Autor: Adrian Boehlen
#
# Programm dient zur Korrektur der durch Erfassen.awk erzeugten Daten
# Zu Beginn wird ein Backup der Tabelle 'teilnehmer.csv' angelegt
# Je nach Kategorie wird der bewilligte Zuschlag addiert, falls ein Resultat vorliegt
# Resultate werden in Prozente zum Maximum berechnet
# DB-File wird aktualisiert
#
#########################################################################################

########## Backup- und Logfile vorbereiten und Feldseparator definieren ##########

bakfile = "teilnehmer.csv.bak";
logfile = strftime("%Y%m%d", systime()) ".log";

do {
  ########## DB-File in zweidimensionalen Array einlesen und Backup anlegen ##########
  
  now = strftime("%a %b %d %H:%M:%S %Y", systime()); # Zeitstempel fuer Logfile
  db_einlesen(dbfile);
  anz_teiln = t - 1;                   # Anzahl Teilnehmer ableiten

  while ((getline < dbfile) > 0) {
    print $0 > bakfile;                # Backup erstellen
  }
  close(dbfile);
  close(bakfile);

  ########## Teilnehmer ausgeben ##########

  print "\n*************************";
  print "Erfasste Schuetzen";
  print "*************************";
 
  for (comb in teilnehmer) {
    split(comb, sep, SUBSEP);
    if (sep[1] == "schuetze") {
      print teilnehmer["schuetze", sep[2]];
    }
  }
  print "*************************";


  ########## Auswahl Schuetze ##########

  do {
    print "\nName des Schuetzen, dessen Daten korrigiert werden sollen: ";
    getline schuetze;
  } while (schuetze ~ /^$/);

  ########## Auswahl Schiessen ##########

  do {
    print "\n**************************************";
    print "Zu korrigierendes Schiessen auswaehlen";
    print "**************************************\n";
    print "Obligatorisches Programm\t<1>";
    print "Voruebung Feldschiessen\t\t<2>";
    print "Feldschiessen\t\t\t<3>";
    print "Grauholzschiessen\t\t<4>";
    print "Maerzschiessen\t\t\t<5>";
    print "Einzelwettschiessen\t\t<6>";
    print "Mingerschiessen\t\t\t<7>";
    print "Von der HV bestimmter Anlass\t<8>";
    #print "Vancouverstich\t\t\t<9>";
    print "Bubenbergschiessen\t\t<9>";
    print "Sektionsstich\t\t\t<10>";
    print "Standstich\t\t\t<11>";
    print "Schnellstich\t\t\t<12>";
    print "Kunststich\t\t\t<13>";
    print "abbrechen\t\t\t<14>";
    getline schiessen;
  } while (schiessen < 1 || schiessen > 14);

  ########## Resultate korrigieren ##########

  exist = 0;
  for (comb in teilnehmer) {
    split(comb, sep, SUBSEP);
    if (teilnehmer[sep[1], sep[2]] == schuetze) {
      exist = 1;

      # OP
      if (schiessen == 1) {
        do {
          printf("    Obligatorisches Programm: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 85);

        split(erf_op(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["op_r", sep[2]] = daten[1];
        teilnehmer["op_p", sep[2]] = daten[2];
        teilnehmer["op_z", sep[2]] = daten[3];
        teilnehmer["op_k", sep[2]] = daten[4];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", OP: " teilnehmer["op_r", sep[2]] " Pt., " teilnehmer["op_p", sep[2]] " %" >> logfile;
      }

      # VFS
      if (schiessen == 2) {
        do {
          printf("    Voruebung Feldschiessen: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 72);

        split(erf_vfs(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["vfs_r", sep[2]] = daten[1];
        teilnehmer["vfs_p", sep[2]] = daten[2];
        teilnehmer["vfs_z", sep[2]] = daten[3];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", VFS: " teilnehmer["vfs_r", sep[2]] " Pt., " teilnehmer["vfs_p", sep[2]] " %" >> logfile;
      }

      # FS
      if (schiessen == 3) {
        do {
          printf("    Feldschiessen: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 72);

        split(erf_fs(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["fs_r", sep[2]] = daten[1];
        teilnehmer["fs_p", sep[2]] = daten[2];
        teilnehmer["fs_z", sep[2]] = daten[3];
        teilnehmer["fs_k", sep[2]] = daten[4];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", FS: " teilnehmer["fs_r", sep[2]] " Pt., " teilnehmer["fs_p", sep[2]] " %" >> logfile;
      }

      # Grauholzschiessen
      if (schiessen == 4) {
        do {
          printf("    Grauholzschiessen: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 60);

        split(erf_gr(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["gr_r", sep[2]] = daten[1];
        teilnehmer["gr_p", sep[2]] = daten[2];
        teilnehmer["gr_z", sep[2]] = daten[3];
        teilnehmer["gr_k", sep[2]] = daten[4];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Grauholz: " teilnehmer["gr_r", sep[2]] " Pt., " teilnehmer["gr_p", sep[2]] " %" >> logfile;
      }

      # Maerzschiessen
      if (schiessen == 5) {
        do {
          printf("    Maerzschiessen: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

        split(erf_mar(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["mar_r", sep[2]] = daten[1];
        teilnehmer["mar_p", sep[2]] = daten[2];
        teilnehmer["mar_z", sep[2]] = daten[3];
        teilnehmer["mar_k", sep[2]] = daten[4];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Maerz: " teilnehmer["mar_r", sep[2]] " Pt., " teilnehmer["mar_p", sep[2]] " %" >> logfile;
      }

      # Einzelwettschiessen
      if (schiessen == 6) {
        do {
          printf("    Einzelwettschiessen: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 200);

        split(erf_ews(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["ews_r", sep[2]] = daten[1];
        teilnehmer["ews_p", sep[2]] = daten[2];
        teilnehmer["ews_z", sep[2]] = daten[3];
        teilnehmer["ews_k", sep[2]] = daten[4];
        teilnehmer["feld", sep[2]]  = daten[5];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Einzelwett: " teilnehmer["ews_r", sep[2]] " Pt., " teilnehmer["ews_p", sep[2]] " %" >> logfile;
      }

      # Mingerschiessen
      if (schiessen == 7) {
        do {
          printf("    Mingerschiessen: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 40);

        split(erf_mi(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["mi_r", sep[2]] = daten[1];
        teilnehmer["mi_p", sep[2]] = daten[2];
        teilnehmer["mi_z", sep[2]] = daten[3];
        teilnehmer["mi_k", sep[2]] = daten[4];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Minger: " teilnehmer["mi_r", sep[2]] " Pt., " teilnehmer["mi_p", sep[2]] " %" >> logfile;
      }

      # Offizieller Anlass
      if (schiessen == 8) {
        do {
          printf("    Von der HV bestimmter Anlass: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

        split(erf_hv(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["hv_r", sep[2]] = daten[1];
        teilnehmer["hv_p", sep[2]] = daten[2];
        teilnehmer["hv_z", sep[2]] = daten[3];
        teilnehmer["hv_k", sep[2]] = daten[4];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Off. Anl: " teilnehmer["hv_r", sep[2]] " Pt., " teilnehmer["hv_p", sep[2]] " %" >> logfile;
      }

      # Vancouverstich # gemaess Vorstandsbeschluss 2018 nicht mehr Teil der Jahresmeisterschaft
      #if (schiessen == 9) {
      #  do {
      #    printf("    Vancouverstich: ");
      #    getline eingabe;
      #  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

      #  split(erf_van(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
      #  teilnehmer["van_r", sep[2]] = daten[1];
      #  teilnehmer["van_p", sep[2]] = daten[2];
      #  teilnehmer["van_z", sep[2]] = daten[3];
      #  teilnehmer["van_k", sep[2]] = daten[4];

      #  print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
      #  ", Vancouver: " teilnehmer["van_r", sep[2]] " Pt., " teilnehmer["van_p", sep[2]] " %" >> logfile;
      #}

      # Bubenbergschiessen
      if (schiessen == 9) {
        do {
          printf("    Bubenbergschiessen: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

        split(erf_bub(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["bub_r", sep[2]] = daten[1];
        teilnehmer["bub_p", sep[2]] = daten[2];
        teilnehmer["bub_z", sep[2]] = daten[3];
        teilnehmer["bub_k", sep[2]] = daten[4];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Bubenberg: " teilnehmer["bub_r", sep[2]] " Pt., " teilnehmer["bub_p", sep[2]] " %" >> logfile;
      }

      # Sektionsstich
      if (schiessen == 10) {
        do {
          printf("    Sektionsstich: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 40);

        split(erf_sek(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["sek_r", sep[2]] = daten[1];
        teilnehmer["sek_p", sep[2]] = daten[2];
        teilnehmer["sek_z", sep[2]] = daten[3];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Sektion: " teilnehmer["sek_r", sep[2]] " Pt., " teilnehmer["sek_p", sep[2]] " %" >> logfile;
      }

      # Standstich
      if (schiessen == 11) {
        do {
          printf("    Standstich: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

        split(erf_st(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["st_r", sep[2]] = daten[1];
        teilnehmer["st_p", sep[2]] = daten[2];
        teilnehmer["st_z", sep[2]] = daten[3];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Stand: " teilnehmer["st_r", sep[2]] " Pt., " teilnehmer["st_p", sep[2]] " %" >> logfile;
      }

      # Schnellstich
      if (schiessen == 12) {
        do {
          printf("    Schnellstich: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 40);

        split(erf_sch(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["sch_r", sep[2]] = daten[1];
        teilnehmer["sch_p", sep[2]] = daten[2];
        teilnehmer["sch_z", sep[2]] = daten[3];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Schnell: " teilnehmer["sch_r", sep[2]] " Pt., " teilnehmer["sch_p", sep[2]] " %" >> logfile;
      }

      # Kunststich
      if (schiessen == 13) {
        do {
          printf("    Kunststich: ");
          getline eingabe;
        } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 500);

        split(erf_kun(teilnehmer["kategorie", sep[2]], eingabe), daten, " ");
        teilnehmer["kun_r", sep[2]] = daten[1];
        teilnehmer["kun_p", sep[2]] = daten[2];
        teilnehmer["kun_z", sep[2]] = daten[3];

        print now " - " teilnehmer["schuetze", sep[2]] ": "  teilnehmer["kategorie_j", sep[2]]\
        ", Kunst: " teilnehmer["kun_r", sep[2]] " Pt., " teilnehmer["kun_p", sep[2]] " %" >> logfile;
      }

      # abbrechen
      if (schiessen == 14) {
        print now " - " teilnehmer["schuetze", sep[2]] ": keine Korrektur durchgefuehrt" >> logfile;
        break;
      }
    }
  }
  close(logfile);

  # Falls Schuetze nicht existiert, Programmdurchlauf wiederholen
  if (exist == 0) {
    print "\nGesuchter Schuetze existiert nicht!\n";
    continue;
  }

  ########## Anzahl Resultate und Kraenze aktualisieren ##########

  # Array mit den Bezeichnungen der Resultatsfelder aufbauen
  i = 1;
  new(resultate);
  for (comb in teilnehmer) {
    split(comb, sep, SUBSEP);
    if (sep[2] == 1) {
      if (sep[1] ~ /.+_r/) {
        resultate[i] = sep[1];
        i++;
      }
    }
  }  
  
  # Array mit den Bezeichnungen der Kranzfelder aufbauen
  i = 1;
  new(kraenze);
  for (comb in teilnehmer) {
    split(comb, sep, SUBSEP);
    if (sep[2] == 1) {
      if (sep[1] ~ /.+_k/) {
        kraenze[i] = sep[1];
        i++;
      }
    }
  } 
  
  # Anzahl Resultate und Kraenze ermitteln
  resanz = 0;
  kranzanz = 0;
  for (comb in teilnehmer) {
    split(comb, sep, SUBSEP);
    if (teilnehmer[sep[1], sep[2]] == schuetze) {
      for (r in resultate)
        resanz += res(teilnehmer[resultate[r], sep[2]]);
      teilnehmer["resultate", sep[2]] = resanz; 

      for (k in kraenze)
        kranzanz += teilnehmer[kraenze[k], sep[2]];
      teilnehmer["kraenze", sep[2]] = kranzanz;
    }
  }

  ########## Daten in DB-File schreiben ##########

  printf("")                     > dbfile;                       # DB-File neu anlegen 

  # Feldbezeichnungen schreiben

  asort(fields);                                                 # Feldbezeichnungen sortieren
  for (f = 1; f <= length(fields); f++) {
    if (f < length(fields))
      printf("%s,", fields[f])  > dbfile;                        # Feldbezeichnungen mit Komma trennen...
    else
      printf("%s", fields[f])   > dbfile;                        # ...ausser bei der letzten
  }
  printf("\n")                  > dbfile;                        # Zeilenumbruch am Ende einfuegen

  # Daten anfuegen

  for (t = 1; t <= anz_teiln; t++) {                             # fuer jeden Teilnehmer
    for (f = 1; f <= length(fields); f++) {                      # fuer jedes Feld
      for (comb in teilnehmer) {                                 # fuer jeden kombinierten Index
        split(comb, sep, SUBSEP);                                # Index aufsplitten
        if (sep[1] == fields[f] && sep[2] == t) {                # Feldwerte in sortierter Reihenfolge nach Teilnehmer 
          if (f < length(fields))
            printf("%s,", teilnehmer[sep[1], sep[2]])  > dbfile; # Feldbezeichnungen mit Komma trennen...
          else
            printf("%s", teilnehmer[sep[1], sep[2]])   > dbfile; # ...ausser bei der letzten
        }
      }
    }
    printf("\n")                                       > dbfile; # Zeilenumbruch am Ende einfuegen
  }
  close(dbfile);

  ########## weiteres Vorgehen definieren ##########

  do {
    print "\n********************************";
    print "Weitere Korrektur durchfuehren ?";
    print "********************************\n";
    print "Ja\t\t<1>";
    print "Nein\t\t<2>";
    getline antwort;
    if (antwort == 1)
      continue;
    else if (antwort == 2)
      break;
  } while (antwort !~ /^1$|^2$/);
} while (antwort != 2);


}

