function standblatt(    antwort, author, b, begr_links, begr_rechts, create_pdf, datum, i,\
 inhalt, jahr, passm_links, pat, pdf, pdf_file, pdf_part, programm1, programm2, programm3,\
 schiessen, stbl_br, stbl_file, stich, text_links, zeit) {

#########################################################################################
#
# Standblattprogramm V2.1.5  05.04.2021
#
# Autor: Adrian Boehlen 
#
# Programm erzeugt Standblaetter fuer die Jahresmeisterschaft der 
# Feldschuetzen Bolligen im PDF-Format.
# Es werden 4 Blaetter auf eine A4-Seite quer gedruckt
#
#########################################################################################

titel = "\n\
      *********************************************************************************\n\
      *                                                                               *\n\
      *                       Jahresmeisterschaft FS Bolligen                         *\n\
      *                                                                               *\n\
      *                      Standblattprogramm, Version 2.1.5                        *\n\
      *                                                                               *\n\
      *                                   05.04.2021                                  *\n\
      *                                                                               *\n\
      *********************************************************************************\n";

print titel;

########## Daten erheben ##########

do {
  printf("Jahr des Schiessens: ");
  getline jahr;
} while (jahr !~ /^[0-9]+$/ || jahr < 2020 || jahr > 2050);

do {
  print "\n************************************************************************************";
  print "Zu erstellendes Standblatt definieren";
  do {
    print "************************************************************************************\n";
    print "Jahresmeisterschaft\t\t\t\t\tEndschiessen";
    print "*******************\t\t\t\t\t************";
    print "Sektion 1. Passe\t\t<1>\t\t\tUebungskehr\t\t<11>";
    print "Sektion 2. Passe\t\t<2>\t\t\tGaben Hauptdoppel\t<12>";
    print "Standstich 1. Passe\t\t<3>\t\t\tGaben Nachdoppel\t<13>";
    print "Standstich 2. Passe\t\t<4>\t\t\tBantiger Hauptdoppel\t<14>";
    print "Schnellstich 1. Passe\t\t<5>\t\t\tBantiger Nachdoppel\t<15>";
    print "Schnellstich 2. Passe\t\t<6>\t\t\tKristallstich\t\t<16>";
    print "Kunststich\t\t\t<7>";
    print "Vorueben Feldsch. 1. Passe\t<8>";
    print "Vorueben Feldsch. 2. Passe\t<9>";
    print "Vorueben Feldsch. 3. Passe\t<10>";
    print "\nbenutzerdefiniert\t\t<17>";
    getline stich;
  } while (stich !~ /^[0-9]+$/ || stich < 1 || stich > 17);
  
  # Variablen setzen

  if (stich == 1) {
    schiessen = "Jahresmeisterschaft";
    stich = "Sektion 1. Passe";
    programm1 = "Programm A5:";
    programm2 = "5 Einzel";
    programm3 = "3 in 1 Minute";
    stbl_file = "sektion01";
  }
  else if (stich == 2) {
    schiessen = "Jahresmeisterschaft";
    stich = "Sektion 2. Passe";
    programm1 = "Programm A5:";
    programm2 = "5 Einzel";
    programm3 = "3 in 1 Minute";
    stbl_file = "sektion02";
  }
  else if (stich == 3) {
    schiessen = "Jahresmeisterschaft";
    stich = "Standstich 1. Passe";
    programm1 = "Programm A10:";
    programm2 = "10 Einzel";
    programm3 = "";
    stbl_file = "stand01";
  }
  else if (stich == 4) {
    schiessen = "Jahresmeisterschaft";
    stich = "Standstich 2. Passe";
    programm1 = "Programm A10:";
    programm2 = "10 Einzel";
    programm3 = "";
    stbl_file = "stand02";
  }
  else if (stich == 5) {
    schiessen = "Jahresmeisterschaft";
    stich = "Schnellstich 1. Passe";
    programm1 = "Programm A5:";
    programm2 = "2 x 4 Schuss";
    programm3 = "Kar. 60\" Stgw. 40\"";
    stbl_file = "schnell01";
  }
  else if (stich == 6) {
    schiessen = "Jahresmeisterschaft";
    stich = "Schnellstich 2. Passe";
    programm1 = "Programm A5:";
    programm2 = "2 x 4 Schuss";
    programm3 = "Kar. 60\" Stgw. 40\"";
    stbl_file = "schnell02";
  }
  else if (stich == 7) {
    schiessen = "Jahresmeisterschaft";
    stich = "Kunststich";
    programm1 = "Programm A100:";
    programm2 = "5 Einzel";
    programm3 = "";
    stbl_file = "kunst";
  }
  else if (stich == 8) {
    schiessen = "Jahresmeisterschaft";
    stich = "Vor\374ben Feldsch. 1. Passe";
    programm1 = "";
    programm2 = "";
    programm3 = "";
    stbl_file = "vfs01";
  }
  else if (stich == 9) {
    schiessen = "Jahresmeisterschaft";
    stich = "Vor\374ben Feldsch. 2. Passe";
    programm1 = "";
    programm2 = "";
    programm3 = "";
    stbl_file = "vfs02";
  }
  else if (stich == 10) {
    schiessen = "Jahresmeisterschaft";
    stich = "Vor\374ben Feldsch. 3. Passe";
    programm1 = "";
    programm2 = "";
    programm3 = "";
    stbl_file = "vfs03";
  }
  else if (stich == 11) {
    schiessen = "Endschiessen";
    stich = "\334bungskehr";
    programm1 = "Programm A10: ";
    programm2 = "5 Einzel";
    programm3 = "";
    stbl_file = "uebungskehr";
  }
  else if (stich == 12) {
    schiessen = "Endschiessen";
    stich = "Gaben Hauptdoppel";
    programm1 = "Programm A100: ";
    programm2 = "10 Einzel";
    programm3 = "";
    stbl_file = "gaben_hd";
  }
  else if (stich == 13) {
    schiessen = "Endschiessen";
    stich = "Gaben Nachdoppel";
    programm1 = "Programm A100: ";
    programm2 = "2 Einzel";
    programm3 = "";
    stbl_file = "gaben_nd";
  }
  else if (stich == 14) {
    schiessen = "Endschiessen";
    stich = "Bantiger Hauptdoppel";
    programm1 = "Programm A100: ";
    programm2 = "3 Einzel";
    programm3 = "";
    stbl_file = "bantiger_hd";
  }
  else if (stich == 15) {
    schiessen = "Endschiessen";
    stich = "Bantiger Nachdoppel";
    programm1 = "Programm A100: ";
    programm2 = "3 Einzel";
    programm3 = "";
    stbl_file = "bantiger_nd";
  }
  else if (stich == 16) {
    schiessen = "Endschiessen";
    stich = "Kristallstich";
    programm1 = "Programm A10: ";
    programm2 = "6 Einzel";
    programm3 = "4 Serie";
    stbl_file = "kristall";
  }
  else if (stich == 17) {
    do {
      printf("Name des Schiessens eingeben: ");
      getline schiessen;
    } while (schiessen ~ /^$/);
    do {
      printf("Name des Stiches eingeben: ");
      getline stich;
    } while (stich ~ /^$/);
    do {
      printf("Name des Programms eingeben: ");
      getline programm1;
    } while (programm1 ~ /^$/);
    printf("ggf. erlaubte Zeit im Schnellfeuer eingeben (Enter falls nicht benoetigt): ");
    getline programm3;
    do {
      printf("Zu erstellendes Standblatt-File definieren (ohne Dateiendung!): ");
      getline stbl_file;
    } while (stbl_file ~ /^$/);
  }
  else {
    print "\nUnbekannter Fehler!\n";
    print "...Programm wird beendet...\n";
  }
  
  ########## Variablen fuer PDF initialisieren ########## 
  
  # alle Masse in mm (ausser Textgroesse)
  # Umlaute wie folgt codieren:
  # Ae: \304
  # ae: \344
  # Oe: \326
  # oe: \366
  # Ue: \334
  # ue: \374
  
  author = "Adrian B\\366hlen";
  b = " ";                        # Leerzeichen als Trenner fuer Koordinaten
  pdf_file = stbl_file ".pdf";
  stbl_br =     70.2;
  begr_links =  9.2;
  begr_rechts = 79;
  text_links =  13;
  passm_links = 67;
  datum =       51.2;
  zeit =        42.3;

  ########## PDF aufbauen ##########
  
  # PDF-Header und linke Begrenzungslinie 
  pdf = pdf_header(author, stich, "4 Standbl\\344tter auf A4 quer");
  pdf = pdf pdf_pages_font("Helvetica-Bold F1");
  pdf = pdf pdf_page(297, 210);
  inhalt = line_width(0.3);
  inhalt = inhalt stroke_line(begr_links b 0.4 b begr_links b 210); 

  # vier Durchgaenge fuer den Inhalt
  for (i = 1; i <= 4; i++) {
    # Linien zeichnen
    inhalt = inhalt line_width(0.3);
    inhalt = inhalt stroke_line(begr_rechts b 1 b begr_rechts b 210);
    inhalt = inhalt stroke_line(begr_links b 185 b begr_rechts b 185);
    inhalt = inhalt stroke_line(begr_links b 178 b begr_rechts b 178);
    inhalt = inhalt stroke_line(begr_links b 156 b begr_rechts b 156);
    inhalt = inhalt stroke_line(begr_links b 28 b begr_rechts b 28);
    inhalt = inhalt stroke_line(begr_links b 16 b begr_rechts b 16);
    inhalt = inhalt line_width(0.9);
    inhalt = inhalt stroke_line(passm_links b 156 b begr_rechts b 156);

    # Text setzen
    inhalt = inhalt set_text("F1", 16, text_links, 194, "Feldsch\\374tzen Bolligen");
    inhalt = inhalt set_text("F1", 10, text_links, 188, schiessen " " jahr);
    inhalt = inhalt set_text("F1", 12, text_links, 180, stich);
    inhalt = inhalt set_text("F1", 10, text_links, 172, "Name:");
    inhalt = inhalt set_text("F1", 10, text_links, 165, "Vorname:");
    inhalt = inhalt set_text("F1", 10, text_links, 158, "Jahrgang:");
    inhalt = inhalt set_text("F1", 10, text_links, 149, programm1);
    inhalt = inhalt set_text("F1", 10, zeit, 149, programm2);
    inhalt = inhalt set_text("F1", 10, zeit, 145, programm3);
    inhalt = inhalt set_text("F1", 10, text_links, 20, "Warner:");
    inhalt = inhalt set_text("F1", 10, datum, 20, "Datum:");
    inhalt = inhalt set_text("F1", 10, text_links, 9, "Sch\\374tze:");

    # Variablen inkrementieren fuer naechstes Standblatt
    begr_links += stbl_br;
    begr_rechts += stbl_br;
    text_links += stbl_br; 
    passm_links += stbl_br;
    datum += stbl_br;
    zeit += stbl_br;
  }	

  # PDF abschliessen und speichern
  pdf = pdf pdf_inhalt(length(inhalt));
  pdf = pdf inhalt;
  pdf = pdf endinhalt();
  for (i = 1; i <= objectnr_max; i++) {          # alle Objekte durchgehen
    pat = i " 0 obj.*";                          # Muster fuer jedes Objekt festlegen
    pdf_part = pdf;                              # Kopie von pdf erstellen
    sub(pat, "", pdf_part);                      # alles ab dem Muster loeschen
    adresse[i] = length(pdf_part);               # Laenge des restlichen Codes festhalten
  }
  
  pdf = pdf pdf_xref();                          # Referenztabelle berechnen und anfuegen
  
  pdf_part = pdf;                                # Kopie von pdf erstellen
  sub(/xref.*/, "", pdf_part);                   # alles ab xref loeschen
  adresse[objectnr_max] = length(pdf_part);      # Laenge des Rests im hoechsten Arrayindex festhalten
  pdf = pdf pdf_trailer();
  print pdf > pdf_file;
  close(pdf_file);

  ########## weiteres Vorgehen definieren ##########

  do {
    print "\n*******************************";
    print "Weiteres Standblatt erstellen ?";
    print "*******************************\n";
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

