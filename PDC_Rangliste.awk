function pdc_rangliste(    abst, anz_teiln, gutp1, gutp2, heute, infile, jahr, nextyear,\
pdcfile, s_header, s_text, teiln_a, vpos, zaehler) {

#########################################################################################
#
# PDC_Rangliste V1.0.2  31.10.2018
#
# Autor: Adrian Boehlen
#
# Programm erzeugt eine Rangliste im gewohnten Look&Feel im PDC-Format
# Dieses File muss anschliessend mittels pdf_generator.awk in ein PDF konvertiert werden
# Bedingung: Die Tabelle "auswertung.csv" muss erzeugt worden sein
# 
#########################################################################################

########## Vorbereitungen ##########

heute = strftime("%d.%m.%Y", systime());

infile = "auswertung.csv";

if ((getline < infile) == -1) {
  print "Tabelle \"auswertung.csv\" existiert nicht";
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

nextyear = jahr + 1;

pdcfile = "rangliste_" jahr ".pdc";

do {
  printf("Anzahl der Teilnehmer in der Kategorie A angeben: ");
  getline teiln_a;
} while (teiln_a ~ /^$/ || teiln_a < 3 || teiln_a > 20);

########## Auswertungstabelle in zweidimensionalen Array einlesen ##########

db_einlesen(infile);
anz_teiln = t - 1;                   # Anzahl Teilnehmer ableiten

########## PDC-Datei aufbauen ##########

s_header = 8; # Schriftgroesse fuer Kopf- und Fusszeile
s_text =  12; # Schriftgroesse fuer normalen Text

# Header und Metadaten

print "filename rangliste_" jahr ".pdf"                                  > pdcfile;
print "author Adrian Böhlen"                                             > pdcfile;
print "title Rangliste Jahresmeisterschaft " jahr                        > pdcfile;
print "subject Jahresmeisterschaft"                                      > pdcfile;
print "page_size 210 297"                                                > pdcfile;
print "font Helvetica F1"                                                > pdcfile;
print "font Helvetica-Bold F2"                                           > pdcfile;
print "text F1 " s_header " 6 287 Jahresmeisterschaft FS Bolligen"       > pdcfile;
print "text F1 " s_header " 155 287 Rangliste Jahresmeisterschaft " jahr > pdcfile;
print "text F1 " s_header " 6 8 rangliste_" jahr ".pdc"                  > pdcfile;
print "text F1 " s_header " 92 8 Adrian Böhlen"                          > pdcfile;
print "text F1 " s_header " 190 8 " heute                                > pdcfile;

# Titel der Rangliste

print "text F1 22 62 261 Jahresmeisterschaft " jahr             > pdcfile;
print "text F1 14 77 243 (Beteiligung: " anz_teiln " Schützen)" > pdcfile;


########## Kategorie A ##########

vpos = 223;  # vertikale Position des ersten Eintrages
abst = 8;    # Zeilenabstand
zaehler = 0;

print "text F2 " s_text " 20 " vpos " Kat. A"     > pdcfile;
print "text F2 " s_text " 110 " vpos " Total"     > pdcfile;
print "text F2 " s_text " 161 " vpos " Gutpunkte" > pdcfile;

for (t = 1; t <= anz_teiln; t++) {                                     # fuer jeden Teilnehmer
  for (f = 1; f <= length(fields); f++) {                              # fuer jedes Feld
    for (comb in teilnehmer) {                                         # fuer jeden kombinierten Index
      split(comb, sep, SUBSEP);                                        # Index aufsplitten
      if (sep[1] == fields[f] && sep[2] == t) {                        # Feldwerte in sortierter Reihenfolge nach Teilnehmer
        if (sep[1] == "schuetze") {
          if (teilnehmer["kategorie_j", sep[2]] == "a") {
            zaehler++;
            vpos = vpos - abst;
            print zaehler ". Schuetze der Kategorie A wird berechnet";

            # Rang nur wenn erfuellt
            if (teilnehmer["erfuellt", sep[2]] == 1)
              print "text F1 " s_text " 20 " vpos " " zaehler ". "                       > pdcfile;

            # die drei letzten mit Stern
            if (zaehler == teiln_a  || zaehler == teiln_a - 1 || zaehler == teiln_a - 2)
              print "text F1 " s_text " 27 " vpos " " teilnehmer["nachname", sep[2]] "*" > pdcfile;
            else 
              print "text F1 " s_text " 27 " vpos " " teilnehmer["nachname", sep[2]]     > pdcfile;
            print "text F1 " s_text " 62 " vpos " " teilnehmer["vorname", sep[2]]        > pdcfile;

            # Alterskategorien auffuehren
            if (teilnehmer["kategorie", sep[2]] == "sv")
              print "text F1 " s_text " 96 " vpos " SV"                                  > pdcfile;
            else if (teilnehmer["kategorie", sep[2]] == "v")
              print "text F1 " s_text " 96 " vpos " V"                                   > pdcfile;
            else if (teilnehmer["kategorie", sep[2]] == "d")
              print "text F1 " s_text " 96 " vpos " D"                                   > pdcfile;
            else if (teilnehmer["kategorie", sep[2]] == "j")
              print "text F1 " s_text " 96 " vpos " J"                                   > pdcfile;
          
            # Teilnehmer, die erfuellt haben, mit Total und Gutpunkten auffuehren
            if (teilnehmer["erfuellt", sep[2]] == 1) {
              print "text F1 " s_text " 110 " vpos " " teilnehmer["total", sep[2]]       > pdcfile;
          
              # bei den ersten dreien zusaetzlich "Preis" vermerken
              if (zaehler == 1 || zaehler == 2 || zaehler == 3)
                print "text F1 " s_text " 139 " vpos " (Preis)"                          > pdcfile;
          
              # Gutpunkte berechnen und ergaenzen
              gutp1 = teilnehmer["kraenze", sep[2]] * 2;
              gutp2 = teilnehmer["gutpte", sep[2]];
              if (gutp1 < 10)
                print "text F1 " s_text " 163 " vpos " " gutp1                           > pdcfile;
              else
                print "text F1 " s_text " 161 " vpos " " gutp1                           > pdcfile;
              print "text F1 " s_text " 168 " vpos " +"                                  > pdcfile;
              if (gutp2 < 10)
                print "text F1 " s_text " 174 " vpos " " gutp2                           > pdcfile;
              else
              print "text F1 " s_text " 172 " vpos " " gutp2                             > pdcfile;
              print "text F1 " s_text " 179 " vpos " ="                                  > pdcfile;
              if ((gutp1 + gutp2) < 10)
                print "text F1 " s_text " 185 " vpos " " (gutp1 + gutp2)                 > pdcfile;
              else
              print "text F1 " s_text " 183 " vpos " " (gutp1 + gutp2)                   > pdcfile;
            }

            # spezieller Vermerk wenn nicht erfuellt
            else
              print "text F1 " s_text " 110 " vpos " zuwenig  Resultate"                 > pdcfile;
          }
        }
      }
    }
  }
}


########## Kategorie B ##########

vpos = vpos - 17;
zaehler = 0;

print "text F2 " s_text " 20 " vpos " Kat. B"     > pdcfile;
print "text F2 " s_text " 110 " vpos " Total"     > pdcfile;
print "text F2 " s_text " 161 " vpos " Gutpunkte" > pdcfile;

for (t = 1; t <= anz_teiln; t++) {                                     # fuer jeden Teilnehmer
  for (f = 1; f <= length(fields); f++) {                              # fuer jedes Feld
    for (comb in teilnehmer) {                                         # fuer jeden kombinierten Index
      split(comb, sep, SUBSEP);                                        # Index aufsplitten
      if (sep[1] == fields[f] && sep[2] == t) {                        # Feldwerte in sortierter Reihenfolge nach Teilnehmer
        if (sep[1] == "schuetze") {
          if (teilnehmer["kategorie_j", sep[2]] == "b") {
            zaehler++;
            vpos = vpos - abst;
            print zaehler ". Schuetze der Kategorie B wird berechnet";
 
            # Rang nur wenn erfuellt
            if (teilnehmer["erfuellt", sep[2]] == 1)
              print "text F1 " s_text " 20 " vpos " " zaehler ". "                        > pdcfile;

            # die drei ersten mit doppeltem Stern
            if (zaehler == 1 || zaehler == 2 || zaehler == 3)
              print "text F1 " s_text " 27 " vpos " " teilnehmer["nachname", sep[2]] "**" > pdcfile;
            else
              print "text F1 " s_text " 27 " vpos " " teilnehmer["nachname", sep[2]]      > pdcfile;
            print "text F1 " s_text " 62 " vpos " " teilnehmer["vorname", sep[2]]         > pdcfile;

            # Alterskategorien auffuehren
            if (teilnehmer["kategorie", sep[2]] == "sv")
              print "text F1 " s_text " 96 " vpos " SV"                                   > pdcfile;
            else if (teilnehmer["kategorie", sep[2]] == "v")
              print "text F1 " s_text " 96 " vpos " V"                                    > pdcfile;
            else if (teilnehmer["kategorie", sep[2]] == "d")
              print "text F1 " s_text " 96 " vpos " D"                                    > pdcfile;
            else if (teilnehmer["kategorie", sep[2]] == "j")
              print "text F1 " s_text " 96 " vpos " J"                                    > pdcfile;

            # Teilnehmer, die erfuellt haben, mit Total und Gutpunkten auffuehren
            if (teilnehmer["erfuellt", sep[2]] == 1) {
              print "text F1 " s_text " 110 " vpos " " teilnehmer["total", sep[2]]        > pdcfile;

              # bei den ersten dreien zusaetzlich "Preis" vermerken
              if (zaehler == 1 || zaehler == 2 || zaehler == 3)
                print "text F1 " s_text " 139 " vpos " (Preis)"                           > pdcfile;

              # Gutpunkte berechnen und ergaenzen
              gutp1 = teilnehmer["kraenze", sep[2]] * 2;
              gutp2 = teilnehmer["gutpte", sep[2]];
              if (gutp1 < 10)
                print "text F1 " s_text " 163 " vpos " " gutp1                            > pdcfile;
              else
                print "text F1 " s_text " 161 " vpos " " gutp1                            > pdcfile;
              print "text F1 " s_text " 168 " vpos " +"                                   > pdcfile;
              if (gutp2 < 10)
                print "text F1 " s_text " 174 " vpos " " gutp2                            > pdcfile;
              else
                print "text F1 " s_text " 172 " vpos " " gutp2                            > pdcfile;
              print "text F1 " s_text " 179 " vpos " ="                                   > pdcfile;
              if ((gutp1 + gutp2) < 10)
                print "text F1 " s_text " 185 " vpos " " (gutp1 + gutp2)                  > pdcfile;
              else
                print "text F1 " s_text " 183 " vpos " " (gutp1 + gutp2)                  > pdcfile;
            }

            # spezieller Vermerk wenn nicht erfuellt
            else
              print "text F1 " s_text " 110 " vpos " zuwenig  Resultate"                  > pdcfile;
          
          }
        }
      }
    }
  }
}

print "text F1 " s_text " 20 " (vpos - 25) " * Schiessen ab " nextyear " in Kat. B   ** Schiessen ab " nextyear " in Kat. A" > pdcfile;

close(pdcfile);
}
