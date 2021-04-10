function html_rangliste(    anz_teiln, htmlfile, infile, jahr, nextyear, teiln_a, zaehler) {

#########################################################################################
#
# HTML_Rangliste V2.1.3  17.11.2019
#
# Autor: Adrian Boehlen
#
# Programm erzeugt eine Rangliste im gewohnten Look&Feel im XHTML 1.0 - Format
# Bedingung: Die Tabelle "auswertung.csv" muss erzeugt worden sein
# 
#########################################################################################

########## Variablen initialisieren, Dateien vorbereiten und Feldseparator definieren ##########

infile = "auswertung.csv";
htmlfile = "rangliste.html";

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

do {
  printf("Anzahl der Teilnehmer in der Kategorie A angeben: ");
  getline teiln_a;
} while (teiln_a ~ /^$/ || teiln_a < 3 || teiln_a > 20);

########## Auswertungstabelle in zweidimensionalen Array einlesen ##########

db_einlesen(infile);
anz_teiln = t - 1;                   # Anzahl Teilnehmer ableiten

########## HTML-Datei aufbauen ##########
# Header

print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"DTD/xhtml1-strict.dtd\">" > htmlfile;
print "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">" > htmlfile;
print "<head profile=\"http://gmpg.org/xfn/11\">" > htmlfile;
print "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />" > htmlfile;
print "<title>Rangliste Jahresmeisterschaft " jahr "</title>" > htmlfile;
print "<style type=\"text/css\">" > htmlfile;
print "h1 {font-family:Helvetica,sans-serif;font-size:26px;margin-top: 30px;margin-bottom: 20px;}" > htmlfile;
print "p,td {font-family:Helvetica,sans-serif;font-size:18px;}" > htmlfile;
print "</style>" > htmlfile;
print "</head>\n" > htmlfile;

# Titel der Rangliste

print "<body>" > htmlfile;
print "<table border=\"0\" width=\"660\" cellspacing=\"2\" cellpadding=\"0\">" > htmlfile;
print "<tbody>" > htmlfile;
print "<tr>" > htmlfile;
print "<td align=\"center\">" > htmlfile;
print "<h1>" > htmlfile;
print "Jahresmeisterschaft " jahr > htmlfile;
print "</h1>" > htmlfile;
print "<br />" > htmlfile;
print "</td>" > htmlfile;
print "</tr>" > htmlfile;
print "" > htmlfile;
print "<tr>" > htmlfile;
print "<td align=\"center\">" > htmlfile;
print "(Beteiligung " anz_teiln " Sch&uuml;tzen)" > htmlfile;
print "</td>" > htmlfile;
print "</tr>" > htmlfile;
print "" > htmlfile;
print "<tr>" > htmlfile;
print "<td style=\"height:20;\">" > htmlfile;
print "<br />" > htmlfile;
print "<br />" > htmlfile;
print "</td>" > htmlfile;
print "</tr>" > htmlfile;
print "</tbody>" > htmlfile;
print "</table>\n" > htmlfile;

########## Kategorie A ##########

print "<table border=\"0\" cellpadding=\"0\" cellspacing=\"2\" height=\"532\" width=\"660\">" > htmlfile;
print "<tbody>" > htmlfile;
print "<tr>" > htmlfile;
print "<td colspan=\"4\" height=\"21\" width=\"360\"> <span style=\"font-weight: bold;\"> Kat. A </span> </td>" > htmlfile;
print "<td colspan=\"2\" height=\"21\" width=\"96\"> <span style=\"font-weight: bold;\"> Total </span> </td>" > htmlfile;
print "<td colspan=\"5\" height=\"21\" width=\"50\"> <span style=\"font-weight: bold;\"> Gutpunkte </span> </td>" > htmlfile;
print "</tr>" > htmlfile;

for (t = 1; t <= anz_teiln; t++) {                                     # fuer jeden Teilnehmer
  for (f = 1; f <= length(fields); f++) {                              # fuer jedes Feld
    for (comb in teilnehmer) {                                         # fuer jeden kombinierten Index
      split(comb, sep, SUBSEP);                                        # Index aufsplitten
      if (sep[1] == fields[f] && sep[2] == t) {                        # Feldwerte in sortierter Reihenfolge nach Teilnehmer
        if (sep[1] == "schuetze") {
          if (teilnehmer["kategorie_j", sep[2]] == "a") {
            zaehler++;
            print zaehler ". Schuetze der Kategorie A wird berechnet";
          
            print "<tr>" > htmlfile;
            print "<td style=\"width: 20px; height: 16px;\">" > htmlfile;
            if (teilnehmer["erfuellt", sep[2]] == 1)                   # Rang nur wenn erfuellt
              print zaehler ". " > htmlfile;
            else 
              print "&nbsp;" > htmlfile;
            print "</td>" > htmlfile;
          
            print "<td style=\"width: 140px; height: 16px;\">" > htmlfile;
          
            if (zaehler == teiln_a  || zaehler == teiln_a - 1 || zaehler == teiln_a - 2)
              print teilnehmer["nachname", sep[2]] "*" > htmlfile;    # die drei letzten mit Stern
            else 
              print teilnehmer["nachname", sep[2]] > htmlfile;
            
            print "</td>" > htmlfile;
          
            print "<td style=\"width: 140px; height: 16px;\">" > htmlfile;
            print teilnehmer["vorname", sep[2]] > htmlfile;
            print "</td>" > htmlfile;
          
            # Alterskategorien auffuehren
            if (teilnehmer["kategorie", sep[2]] == "sv") {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "SV" > htmlfile;
              print "</td>" > htmlfile;
            }
            else if (teilnehmer["kategorie", sep[2]] == "v") {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "V" > htmlfile;
              print "</td>" > htmlfile;
            }
            else if (teilnehmer["kategorie", sep[2]] == "d") {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "D" > htmlfile;
              print "</td>" > htmlfile;
            }
            else if (teilnehmer["kategorie", sep[2]] == "j") {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "J" > htmlfile;
              print "</td>" > htmlfile;
            }
            else {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
            }
          
            # Teilnehmer, die erfuellt haben, mit Total und Gutpunkten auffuehren
            if (teilnehmer["erfuellt", sep[2]] == 1) {
              print "<td style=\"width: 80px; height: 16px;\">" > htmlfile;
              print teilnehmer["total", sep[2]] > htmlfile;
              print "</td>" > htmlfile;
          
              # bei den ersten dreien zusaetzlich "Preis" vermerken
              if (zaehler == 1 || zaehler == 2 || zaehler == 3) {
                print "<td style=\"width: 120px; height: 16px;text-align:center\">" > htmlfile;
                print "(Preis)" > htmlfile;
                print "</td>" > htmlfile;
              }
              else {
                print "<td style=\"width: 120px; height: 16px;\">" > htmlfile;
                print "&nbsp;" > htmlfile;
                print "</td>" > htmlfile;
              }
          
              # Gutpunkte berechnen und ergaenzen
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print teilnehmer["kraenze", sep[2]] * 2 > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"center\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "+" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print teilnehmer["gutpte", sep[2]] > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"center\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "=" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print teilnehmer["kraenze", sep[2]] * 2 + teilnehmer["gutpte", sep[2]] > htmlfile; 
              print "</td>" > htmlfile;
              print "</tr>" > htmlfile;
            }
      
            # spezieller Vermerk wenn nicht erfuellt
            else {
              print "<td style=\"width: 80px; height: 16px;\">" > htmlfile;
              print "zuwenig" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td style=\"width: 120px; height: 16px;\">" > htmlfile;
              print "Resultate" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"center\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"center\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
              print "</tr>" > htmlfile;
            }
          }
        }
      }
    }
  }
}

print "<tr>" > htmlfile;
print "<td colspan=\"4\" height=\"19\"> <br>" > htmlfile;
print "</td>" > htmlfile;
print "<td colspan=\"2\" height=\"19\"> <br>" > htmlfile;
print "</td>" > htmlfile;
print "<td colspan=\"5\" height=\"19\"> &nbsp; </td>" > htmlfile;
print "</tr>" > htmlfile;

zaehler = 0;

########## Kategorie B ##########

print "<tr>" > htmlfile;
print "<td colspan=\"4\" height=\"21\" width=\"360\"> <span style=\"font-weight: bold;\"> Kat. B </span> </td>" > htmlfile;
print "<td colspan=\"2\" height=\"21\" width=\"96\"> <span style=\"font-weight: bold;\"> Total </span> </td>" > htmlfile;
print "<td colspan=\"5\" height=\"21\" width=\"50\"> <span style=\"font-weight: bold;\"> Gutpunkte </span> </td>" > htmlfile;
print "</tr>" > htmlfile;

for (t = 1; t <= anz_teiln; t++) {                                     # fuer jeden Teilnehmer
  for (f = 1; f <= length(fields); f++) {                              # fuer jedes Feld
    for (comb in teilnehmer) {                                         # fuer jeden kombinierten Index
      split(comb, sep, SUBSEP);                                        # Index aufsplitten
      if (sep[1] == fields[f] && sep[2] == t) {                        # Feldwerte in sortierter Reihenfolge nach Teilnehmer
        if (sep[1] == "schuetze") {
          if (teilnehmer["kategorie_j", sep[2]] == "b") {
            zaehler++;
            print zaehler ". Schuetze der Kategorie B wird berechnet";
          
            print "<tr>" > htmlfile;
            print "<td style=\"width: 20px; height: 16px;\">" > htmlfile;
            if (teilnehmer["erfuellt", sep[2]] == 1)                   # Rang nur wenn erfuellt
              print zaehler ". " > htmlfile;
            else 
              print "&nbsp;" > htmlfile;
            print "</td>" > htmlfile;
          
            print "<td style=\"width: 140px; height: 16px;\">" > htmlfile;
          
            if (zaehler == 1 || zaehler == 2 || zaehler == 3)
              print teilnehmer["nachname", sep[2]] "**" > htmlfile;    # die drei ersten mit doppeltem Stern
            else 
              print teilnehmer["nachname", sep[2]] > htmlfile;
            
            print "</td>" > htmlfile;
          
            print "<td style=\"width: 140px; height: 16px;\">" > htmlfile;
            print teilnehmer["vorname", sep[2]] > htmlfile;
            print "</td>" > htmlfile;
          
            # Alterskategorien auffuehren
            if (teilnehmer["kategorie", sep[2]] == "sv") {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "SV" > htmlfile;
              print "</td>" > htmlfile;
            }
            else if (teilnehmer["kategorie", sep[2]] == "v") {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "V" > htmlfile;
              print "</td>" > htmlfile;
            }
            else if (teilnehmer["kategorie", sep[2]] == "d") {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "D" > htmlfile;
              print "</td>" > htmlfile;
            }
            else if (teilnehmer["kategorie", sep[2]] == "j") {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "J" > htmlfile;
              print "</td>" > htmlfile;
            }
            else {
              print "<td style=\"width: 60px; height: 16px;\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
            }
          
            # Teilnehmer, die erfuellt haben, mit Total und Gutpunkten auffuehren
            if (teilnehmer["erfuellt", sep[2]] == 1) {
              print "<td style=\"width: 80px; height: 16px;\">" > htmlfile;
              print teilnehmer["total", sep[2]] > htmlfile;
              print "</td>" > htmlfile;
          
              # bei den ersten dreien zusaetzlich "Preis" vermerken
              if (zaehler == 1 || zaehler == 2 || zaehler == 3) {
                print "<td style=\"width: 120px; height: 16px;text-align:center\">" > htmlfile;
                print "(Preis)" > htmlfile;
                print "</td>" > htmlfile;
              }
              else {
                print "<td style=\"width: 120px; height: 16px;\">" > htmlfile;
                print "&nbsp;" > htmlfile;
                print "</td>" > htmlfile;
              }
          
              # Gutpunkte berechnen und ergaenzen
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print teilnehmer["kraenze", sep[2]] * 2 > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"center\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "+" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print teilnehmer["gutpte", sep[2]] > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"center\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "=" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print teilnehmer["kraenze", sep[2]] * 2 + teilnehmer["gutpte", sep[2]] > htmlfile; 
              print "</td>" > htmlfile;
              print "</tr>" > htmlfile;
            }
      
            # spezieller Vermerk wenn nicht erfuellt
            else {
              print "<td style=\"width: 80px; height: 16px;\">" > htmlfile;
              print "zuwenig" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td style=\"width: 120px; height: 16px;\">" > htmlfile;
              print "Resultate" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"center\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"center\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
          
              print "<td align=\"right\" width=\"20px\" height=\"16px\">" > htmlfile;
              print "&nbsp;" > htmlfile;
              print "</td>" > htmlfile;
              print "</tr>" > htmlfile;
            }
          }
        }
      }
    }
  }
}

print "</tbody>" > htmlfile;
print "</table>" > htmlfile;
print "<br />" > htmlfile;
print "&nbsp;" > htmlfile;
print "<br />" > htmlfile;
print "&nbsp;" > htmlfile;
print "<p>" > htmlfile;
print "* Schiessen ab " nextyear " in Kat. B&nbsp;&nbsp; ** Schiessen ab " nextyear " in Kat. A" > htmlfile;
print "</p>" > htmlfile;
print "</body>" > htmlfile;
print "</html>" > htmlfile;


close(htmlfile);
}

