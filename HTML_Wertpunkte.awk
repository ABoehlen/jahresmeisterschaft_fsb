function html_wertpunkte(    anf_jahr, anf_jahr_total, anz_schuetzen, ende_jahr_total,\
f, htmlfile, jahr, neu, neu_total, wertpte_tbl) { 

#########################################################################################
#
# HTML_Wertpunkte V2.0.3  17.11.2019
#
# Autor: Adrian Boehlen
#
# Programm erzeugt die Wertpunktetabelle im gewohnten Look&Feel im XHTML 1.0 - Format
# - Bedingung: Die Tabelle "wertpunkte_<Vorjahr>.csv" muss aktualisiert worden sein,
#   d.h. die Funktion <calc wert> muss durchgelaufen sein
# - Die Summe des Punktestandes Anfang Jahr, der neuen Punkte und des 
#   Punktestandes Ende Jahr wird berechnet
# - Die durch <calc wert> erweiterte Tabelle "wertpunkte_<Vorjahr>.csv"
#   wird am Schluss wieder in ihren urspruenglichen Zustand zurueckversetzt
# 
#########################################################################################

########## Variablen initialisieren, Dateien vorbereiten und Feldseparator definieren ##########

htmlfile = "wertpunkte.html";
FS = ",";

do {
  printf("\nJahr der Meisterschaft eingeben: ");
  getline jahr;
} while (jahr ~ /^$/ || jahr < 2010 || jahr > 2030);

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

########## HTML-Datei aufbauen ##########
# Header

print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"DTD/xhtml1-strict.dtd\">" > htmlfile;
print "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" lang=\"en\">" > htmlfile;
print "<head profile=\"http://gmpg.org/xfn/11\">" > htmlfile;
print "<meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\" />" > htmlfile;
print "<title>Wertpunktestand Ende " jahr "</title>" > htmlfile;
print "<style type=\"text/css\">" > htmlfile;
print "h1,td,b,i {" > htmlfile;
print "font-family:Helvetica,sans-serif; }" > htmlfile;
print "h1 { font-size:26px; margin-bottom:18px; }" > htmlfile;
print "p,td { font-size:18px; }" > htmlfile;
print "</style>  " > htmlfile;
print "</head>" > htmlfile;
print "" > htmlfile;

# Titel der Rangliste

print "<body>" > htmlfile;
print "<table border=\"0\" width=\"670\" cellspacing=\"2\" cellpadding=\"0\">" > htmlfile;
print "  <tbody>" > htmlfile;
print "    <tr>" > htmlfile;
print "      <td align=\"center\">" > htmlfile;
print "      <h1>Wertpunktestand Ende " jahr "</h1>" > htmlfile;
print "      <br />" > htmlfile;
print "      <br />" > htmlfile;
print "      </td>" > htmlfile;
print "    </tr>" > htmlfile;
print "  </tbody>" > htmlfile;
print "</table>" > htmlfile;
print "<table bordercolor=\"#000000\" border=\"1\" style=\"width: 660px;\" nosave=\"\"" > htmlfile;
print " cellspacing=\"2\" cellpadding=\"0\">" > htmlfile;
print "  <tbody>" > htmlfile;
print "    <tr>" > htmlfile;
print "      <td width=\"260\" height=\"40\">" > htmlfile;
print "        <span style=\"font-weight: bold;\">Name</span>" > htmlfile;
print "      </td>" > htmlfile;
print "      <td align=\"center\" width=\"100\" height=\"40\">" > htmlfile;
print "        <span style=\"font-weight: bold;\">1.1." jahr "</span>" > htmlfile;
print "      </td>" > htmlfile;
print "      <td align=\"center\" width=\"100\" height=\"40\">" > htmlfile;
print "        <span style=\"font-weight: bold;\">" jahr " bezogen</span>" > htmlfile;
print "      </td>" > htmlfile;
print "      <td align=\"center\" width=\"100\" height=\"40\">" > htmlfile;
print "        <span style=\"font-weight: bold;\">" jahr "</span>" > htmlfile;
print "      </td>" > htmlfile;
print "      <td align=\"center\" width=\"100\" height=\"40\">" > htmlfile;
print "        <span style=\"font-weight: bold;\">Total Ende " jahr "</span>" > htmlfile;
print "      </td>" > htmlfile;
print "    </tr>" > htmlfile;

# HTML-Tabelle erstellen

for (t = 1; t <= anz_schuetzen; t++) {            # fuer jeden Teilnehmer
  for (f = 1; f <= length(fields); f++) {         # fuer jedes Feld
    for (comb in wertpunkte) {                    # fuer jeden kombinierten Index
      split(comb, sep, SUBSEP);                   # Index aufsplitten
      if (sep[1] == fields[f] && sep[2] == t) {   # Feldwerte in sortierter Reihenfolge nach Teilnehmer 
        if (f == 1) {
          # Name
          printf("<tr>\n<td height=\"25\" width=\"260\">%s</td>\n", wertpunkte[sep[1], sep[2]]) > htmlfile;
          print "Wertpunkte von " wertpunkte["schuetze", sep[2]] " werden geschrieben...";
        }
        else if (f == 2) {
          # Wertpunkte Anfang Jahr
          printf("<td align=\"center\" height=\"25\" width=\"100\">%d</td>\n", wertpunkte[sep[1], sep[2]]) > htmlfile;
          anf_jahr = wertpunkte[sep[1], sep[2]];
          anf_jahr_total = anf_jahr_total + anf_jahr;
        }
        else if (f == 3) {
          # Wertpunkte neu aus Jahresmeisterschaft
          printf("<td align=\"center\" height=\"25\" width=\"100\">%d</td>\n", 0) > htmlfile;
          printf("<td align=\"center\" height=\"25\" width=\"100\">%d</td>\n", wertpunkte[sep[1], sep[2]]) > htmlfile;
          neu = wertpunkte[sep[1], sep[2]];
          neu_total = neu_total + neu;
          # Wertpunkte Ende Jahr
          printf("<td align=\"center\" height=\"25\" width=\"100\">%d</td>\n</tr>\n", anf_jahr + neu)  > htmlfile;
          ende_jahr_total = ende_jahr_total + anf_jahr + neu;
        }
      }
    }
  }
}

# Summen ausgeben

printf("<tr>\n<td height=\"25\" width=\"260\">&nbsp;</td>\n") > htmlfile;
printf("<td align=\"center\" height=\"25\" width=\"100\"><span style=\"font-weight: bold;\">%d</span></td>\n", anf_jahr_total) > htmlfile;
printf("<td align=\"center\" height=\"25\" width=\"100\"><span style=\"font-weight: bold;\">%d</span></td>\n", 0) > htmlfile;
printf("<td align=\"center\" height=\"25\" width=\"100\"><span style=\"font-weight: bold;\">%d</span></td>\n", neu_total) > htmlfile;
printf("<td align=\"center\" height=\"25\" width=\"100\"><span style=\"font-weight: bold;\">%d</span></td>\n</tr>\n", ende_jahr_total)  > htmlfile;

# Abschliessende Tags ausgeben

print "  </tbody>" > htmlfile;
print "</table>" > htmlfile;
print "</body>" > htmlfile;
print "</html>" > htmlfile;

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
close(htmlfile);

}

