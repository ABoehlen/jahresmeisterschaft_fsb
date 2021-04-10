function erfassen(    antwort, daten, eingabe, feld, kat, kat_j, kranzanz, logfile, now,\
resultate, sorted, titel, waf) {

#########################################################################################
#
# Erfassen V2.0.4  17.11.2019
#
# Autor: Adrian Boehlen
#
# Programm dient zum Erfassen der Resultate der einzelnen Schuetzen
# Je nach Kategorie wird der bewilligte Zuschlag addiert, falls ein Resultat vorliegt
# Resultate werden in Prozente zum Maximum berechnet
#
#########################################################################################

########## Logfile vorbereiten ##########

logfile = strftime("%Y%m%d", systime()) ".log";

########## Stammdaten erfassen ##########

do {
  new(teilnehmer);
  now = strftime("%a %b %d %H:%M:%S %Y", systime()); # Zeitstempel fuer Logfile
  do {
    printf("\nNachname des Schuetzen: ");
    getline eingabe;
  } while (eingabe ~ /^$/);
  teilnehmer["nachname"] = eingabe;
  
  do {
    printf("Vorname des Schuetzen:  ");
    getline eingabe;
  } while (eingabe ~ /^$/);
  teilnehmer["vorname"] = eingabe;
  teilnehmer["schuetze"] = teilnehmer["nachname"] " " teilnehmer["vorname"];

  print  "#" teilnehmer["schuetze"] >> logfile;

  do {
    print "\nKategorie:";
    print "   Aktive                <a>";
    print "   Jungschuetzen         <j>";
    print "   Damen                 <d>";
    print "   Veteranen             <v>";
    print "   Seniorveteranen       <sv>";
    getline kat;
    teilnehmer["kategorie"] = kat;
  } while (kat !~ /^a$|^j$|^d$|^v$|^sv$/);

  do {
    printf("\nKategorie in der Jahresmeisterschaft <a / b> ");
    getline kat_j;
    teilnehmer["kategorie_j"] = kat_j;
  } while (kat_j !~ /^a$|^b$/);

  do {
    print "\nWaffe:";
    print "   Karabiner             <1>";
    print "   Stgw 57-02            <2>";
    print "   Stgw 90 / Stgw 57-03  <3>";
    print "   Standartgewehr        <4>";
    getline waf;
    teilnehmer["waffe"] = waf;
  } while (waf !~ /^1$|^2$|^3$|^4$/);

  print "\n\nGeben Sie nun die Resultate der einzelnen Schiessen ein:";
  print "(Falls kein Resultat vorliegt, ist 0 einzugeben)\n";

  ########## Schiessresultate erfassen ##########
  # 
  # es koennen nur gueltige Resultete erfasst werden
  # abgeleitete Daten werden ueber separate Funktion ermittelt
  # zurueckgelieferte Daten werden aufgesplittet und in Array abgelegt
  # Arrayelemente werden dem definitiven Array 'teilnehmer' zugewiesen
  # die gueltigen Resultate werden aufsummiert

  # OP
  do {
    printf("Obligatorisches Programm:     ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 85);
  
  split(erf_op(kat, eingabe), daten, " ");
  teilnehmer["op_r"] = daten[1];
  teilnehmer["op_p"] = daten[2];
  teilnehmer["op_z"] = daten[3];
  teilnehmer["op_k"] = daten[4];

  resultate += res(teilnehmer["op_r"]);

  # VFS
  do {
    printf("Voruebung Feldschiessen:      ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 72);

  split(erf_vfs(kat, eingabe), daten, " ");
  teilnehmer["vfs_r"] = daten[1];
  teilnehmer["vfs_p"] = daten[2];
  teilnehmer["vfs_z"] = daten[3];

  resultate += res(teilnehmer["vfs_r"]);

  # FS
  do {
    printf("Feldschiessen:                ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 72);

  split(erf_fs(kat, eingabe), daten, " ");
  teilnehmer["fs_r"] = daten[1];
  teilnehmer["fs_p"] = daten[2];
  teilnehmer["fs_z"] = daten[3];
  teilnehmer["fs_k"] = daten[4];

  resultate += res(teilnehmer["fs_r"]);

  # Grauholz
  do {
    printf("Grauholzschiessen:            ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 60);

  split(erf_gr(kat, eingabe), daten, " ");
  teilnehmer["gr_r"] = daten[1];
  teilnehmer["gr_p"] = daten[2];
  teilnehmer["gr_z"] = daten[3];
  teilnehmer["gr_k"] = daten[4];

  resultate += res(teilnehmer["gr_r"]);

  # Maerzschiessen
  do {
    printf("Maerzschiessen:               ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

  split(erf_mar(kat, eingabe), daten, " ");
  teilnehmer["mar_r"] = daten[1];
  teilnehmer["mar_p"] = daten[2];
  teilnehmer["mar_z"] = daten[3];
  teilnehmer["mar_k"] = daten[4];

  resultate += res(teilnehmer["mar_r"]);

  # Einzelwettschiessen
  do {
    printf("Einzelwettschiessen:          ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 200);

  split(erf_ews(kat, eingabe), daten, " ");
  teilnehmer["ews_r"] = daten[1];
  teilnehmer["ews_p"] = daten[2];
  teilnehmer["ews_z"] = daten[3];
  teilnehmer["ews_k"] = daten[4];
  teilnehmer["feld"]  = daten[5];

  resultate += res(teilnehmer["ews_r"]);

  # Mingerschiessen
  do {
    printf("Mingerschiessen:              ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 40);

  split(erf_mi(kat, eingabe), daten, " ");
  teilnehmer["mi_r"] = daten[1];
  teilnehmer["mi_p"] = daten[2];
  teilnehmer["mi_z"] = daten[3];
  teilnehmer["mi_k"] = daten[4];

  resultate += res(teilnehmer["mi_r"]);

  # Offizieller Anlass
  do {
    printf("Von der HV bestimmter Anlass: ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

  split(erf_hv(kat, eingabe), daten, " ");
  teilnehmer["hv_r"] = daten[1];
  teilnehmer["hv_p"] = daten[2];
  teilnehmer["hv_z"] = daten[3];
  teilnehmer["hv_k"] = daten[4];

  resultate += res(teilnehmer["hv_r"]);

  # Vancouverstich # gemaess Vorstandsbeschluss 2018 nicht mehr Teil der Jahresmeisterschaft
  #do {
  #  printf("Vancouverstich:               ");
  #  getline eingabe;
  #} while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

  #split(erf_van(kat, eingabe), daten, " ");
  #teilnehmer["van_r"] = daten[1];
  #teilnehmer["van_p"] = daten[2];
  #teilnehmer["van_z"] = daten[3];
  #teilnehmer["van_k"] = daten[4];

  #resultate += res(teilnehmer["van_r"]);

  # Bubenbergschiessen
  do {
    printf("Bubenbergschiessen:           ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

  split(erf_bub(kat, eingabe), daten, " ");
  teilnehmer["bub_r"] = daten[1];
  teilnehmer["bub_p"] = daten[2];
  teilnehmer["bub_z"] = daten[3];
  teilnehmer["bub_k"] = daten[4];

  resultate += res(teilnehmer["bub_r"]);

  # Sektionsstich
  do {
    printf("Sektionsstich:                ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 40);

  split(erf_sek(kat, eingabe), daten, " ");
  teilnehmer["sek_r"] = daten[1];
  teilnehmer["sek_p"] = daten[2];
  teilnehmer["sek_z"] = daten[3];

  resultate += res(teilnehmer["sek_r"]);

  # Standstich
  do {
    printf("Standstich:                   ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 100);

  split(erf_st(kat, eingabe), daten, " ");
  teilnehmer["st_r"] = daten[1];
  teilnehmer["st_p"] = daten[2];
  teilnehmer["st_z"] = daten[3];

  resultate += res(teilnehmer["st_r"]);

  # Schnellstich
  do {
    printf("Schnellstich:                 ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 40);

  split(erf_sch(kat, eingabe), daten, " ");
  teilnehmer["sch_r"] = daten[1];
  teilnehmer["sch_p"] = daten[2];
  teilnehmer["sch_z"] = daten[3];

  resultate += res(teilnehmer["sch_r"]);

  # Kunststich
  do {
    printf("Kunststich:                   ");
    getline eingabe;
  } while (eingabe ~ /^$/ || eingabe < 0 || eingabe > 500);

  split(erf_kun(kat, eingabe), daten, " ");
  teilnehmer["kun_r"] = daten[1];
  teilnehmer["kun_p"] = daten[2];
  teilnehmer["kun_z"] = daten[3];

  resultate += res(teilnehmer["kun_r"]);

  ########## Anzahl Resultate und Kraenze ermitteln  ##########

  teilnehmer["resultate"] = resultate;
  resultate = 0;
  
  for (k in teilnehmer) {
    if (k ~ /.+_k/)
      kranzanz += teilnehmer[k];
  }
  teilnehmer["kraenze"] = kranzanz;
  kranzanz = 0;

  ########## Daten ins Logfile schreiben ##########

  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " OP: " teilnehmer["op_r"] " Pt., " teilnehmer["op_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " VFS: " teilnehmer["vfs_r"] " Pt., " teilnehmer["vfs_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " FS: " teilnehmer["fs_r"] " Pt., " teilnehmer["fs_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Grauholz: " teilnehmer["gr_r"] " Pt., " teilnehmer["gr_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Maerz: " teilnehmer["mar_r"] " Pt., " teilnehmer["mar_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Einzelwett: " teilnehmer["ews_r"] " Pt., " teilnehmer["ews_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Minger: " teilnehmer["mi_r"] " Pt., " teilnehmer["mi_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Off.Anl: " teilnehmer["hv_r"] " Pt., " teilnehmer["hv_p"] " %" >> logfile;
  #print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  #" Vancouver: " teilnehmer["van_r"] " Pt., " teilnehmer["van_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Bubenberg: " teilnehmer["bub_r"] " Pt., " teilnehmer["bub_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Sektion: " teilnehmer["sek_r"] " Pt., " teilnehmer["sek_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Stand: " teilnehmer["st_r"] " Pt., " teilnehmer["st_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Schnell: " teilnehmer["sch_r"] " Pt., " teilnehmer["sch_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": " teilnehmer["kategorie_j"]\
  " Kunst: " teilnehmer["kun_r"] " Pt., " teilnehmer["kun_p"] " %" >> logfile;
  print now " - " teilnehmer["schuetze"] ": Anzahl Kraenze: " teilnehmer["kraenze"] >> logfile;
  print now " - " teilnehmer["schuetze"] ": Anzahl Resultate: " teilnehmer["resultate"] >> logfile;
  print "\n" >> logfile;
  close(logfile);

  ########## Daten in DB-File schreiben ##########

  asorti(teilnehmer, sorted);                          # Array teilnehmer nach Index sortieren

  # Falls DB-File noch nicht existiert, Feldbezeichnungen einfuegen
  if (getline < dbfile == -1) { 
    for (i = 1; i <= length(sorted); i++) {
      if (i < length(sorted))
        printf("%s,", sorted[i]) > dbfile;             # Feldbezeichnungen nach Komma trennen...
      else
        printf("%s", sorted[i]) > dbfile;              # ...ausser bei der letzten
    }
    printf("\n") > dbfile;                             # Zeilenumbruch am Ende einfuegen
  }
  else
    close(dbfile);                                     # Falls File existiert, wieder schliessen

  # Werte in die entsprechenden Felder schreiben
  for (i = 1; i <= length(sorted); i++) {
    if (i < length(sorted))
      printf("%s,", teilnehmer[sorted[i]]) >> dbfile;  # Feldbezeichnungen nach Komma trennen...
    else
      printf("%s", teilnehmer[sorted[i]]) >> dbfile;   # ...ausser bei der letzten
  }
  printf("\n") >> dbfile;                              # Zeilenumbruch am Ende einfuegen
  close(dbfile);

  ########## weiteres Vorgehen definieren ##########

  do {
    print "\n*******************************************";
    print "Weiteres Vorgehen?";
    print "*******************************************\n";
    print "Weiterer Schuetze erfassen\t\t<1>";
    print "Daten eines Schuetzen korrigieren\t<2>";
    print "Zum Hauptprogramm zurueck\t\t<3>";
    getline antwort;
    if (antwort == 1) {
      print "*******************************************\n";
      continue;
    }
    else if (antwort == 2) {
      print "*******************************************\n";
      korrektur();
      antwort = 4;  # Ruecksprung ins Hauptprogramm erzwingen
    }
    else if (antwort == 3) {
      break;
    }
  } while (antwort !~ /^1$|^2$|^3$/);
} while (antwort != 3);


}

