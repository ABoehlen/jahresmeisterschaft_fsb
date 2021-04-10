#!/usr/local/bin/awk -f
#########################################################################################
#
# Jahresmeisterschaft V2.1.14  10.04.2021
# Autor: Adrian Boehlen
#
# Programm dient zum Berechnen der Jahresmeisterschaft der FS Bolligen
# Es werden diverse Module im gleichen Verzeichnis benoetigt
# Zum Ableiten einer Standalone Version das Script 'build_jm' verwenden
#
# erfordert Gawk 4.0.0 oder hoeher - ftp://ftp.gnu.org/gnu/gawk/
#
#########################################################################################

########## eingebundene Module ##########

@include "Calc_Rangliste.awk";
@include "Calc_Wertpunkte.awk";
@include "Erfassen.awk";
@include "Funktionen_diverse.awk";
@include "Funktionen_erfassen.awk";
@include "Funktionen_umrechnen.awk";
@include "HTML_Rangliste.awk";
@include "HTML_Wertpunkte.awk";
@include "Kontrolle.awk";
@include "Korrektur.awk";
@include "Parameter.awk";
@include "PDC_Rangliste.awk";
@include "PDC_Wertpunkte.awk";
@include "Standblattprogramm.awk";

# erfordert pdc2pdf Module
@include "../pdc2pdf/PDF_header.awk";
@include "../pdc2pdf/PDF_pages_font.awk";
@include "../pdc2pdf/PDF_page.awk";
@include "../pdc2pdf/PDF_inhalt.awk";
@include "../pdc2pdf/PDF_xref.awk";
@include "../pdc2pdf/PDF_trailer.awk";
@include "../pdc2pdf/PDF_funktionen.awk";

########## Globale Variablen ##########

#adresse      # Array
#bonus_malus  # Array
#char         # Array
#comb         # Skalar
#dbfile       # Skalar
#f            # Skalar
#gutpunkt     # Array
#infile       # Skalar
#kraenze      # Array
#maximum      # Array
#objectnr_max # Skalar
#octTmp       # Array
#outfile      # Skalar
#resultate    # Array
#sep          # Array
#t            # Skalar
#teilnehmer   # Array
#zuschlag     # Array

BEGIN {
  dbfile = "teilnehmer.csv"; # Defaultname fuer DB-File

  titel = "\n\
        *********************************************************************************\n\
        *                                                                               *\n\
        *                       Jahresmeisterschaft FS Bolligen                         *\n\
        *                                                                               *\n\
        *                      Auswertungsprogramm, Version 2.1.14                      *\n\
        *                                                                               *\n\
        *                                   10.04.2021                                  *\n\
        *                                                                               *\n\
        *********************************************************************************\n";

  print titel;

  usage = "\n\
  Befehle und ihre Funktionen:\n\
  ----------------------------\n\
  calc opfs       Berechnet das Total aus OP und FS\n\
  calc rang       Berechnet die Daten fuer die Rangliste\n\
  calc wert       Aktualisiert die Wertpunktetabelle\n\
  erf             Startet das Erfassungsprogramm. Damit werden die Resultate aller Schuetzen erfasst\n\
                  und in einer Tabelle abgelegt. Die Daten werden automatisch gespeichert.\n\
  exit            Beendet das Programm\n\
  kontr           Listet die Resultate aller erfassten Schuetzen zwecks Kontrolle auf\n\
  korr            Startet das Korrekturprogramm. Damit koennen falsch eingegebene Daten berichtigt\n\
                  werden. Die Daten werden automatisch gespeichert.\n\
  plo kontr       Listet die Resultate aller erfassten Schuetzen zwecks Kontrolle auf\n\
                  und schreibt sie in ein Textfile\n\
  plo st          Erzeugt eine A4-Seite mit Standblaettern im PDF-Format\n\
  plo rangh       Erzeugt die Rangliste im XHTML 1.0 - Format\n\
  plo rangp       Erzeugt die Rangliste im PDC - Format\n\
  plo werth       Erzeugt die Wertpunktetabelle im XHTML 1.0 - Format\n\
  plo wertp       Erzeugt die Wertpunktetabelle im PDC - Format\n";
  
  print "Fuer eine genaue Anleitung \"usage\" eingeben\n";
  
  # Wichtige Parameter einlesen
  parameter();

  # Loop
  do {
    printf("\njahresmeisterschaft > ");
    FS = " ";
    getline;
    if ($1 ~ /calc/ && $2 ~ /^$/) {
      print "\n\tUsage:";
      print "\t calc opfs: Berechnet das Total aus OP und FS";
      print "\t calc rang: Berechnet die Daten fuer die Rangliste";
      print "\t calc wert: Berechnet die Daten fuer die Wertpunktetabelle";
    }
    else if ($1 ~ /calc/ && $2 ~ /opfs/)
      calc_opfs(); 
    else if ($1 ~ /calc/ && $2 ~ /rang/)
      calc_rangliste(); 
    else if ($1 ~ /calc/ && $2 ~ /wert/)
      calc_wertpunkte(); 
    else if ($1 ~ /erf/)
      erfassen();
    else if ($1 ~ /exit/)
      print "\n...Programm wird beendet...\n\n";
    else if ($1  ~ /kontr/)
      kontrolle(0);
    else if ($1 ~ /korr/)
      korrektur();
    else if ($1 ~ /plo/ && $2 ~ /^$/) {
      print "\n\tUsage:";
      print "\t plo kontr: Listet die Resultate aller erfassten Schuetzen zwecks Kontrolle auf\n\
                    und schreibt sie in ein Textfile";
      print "\t plo st:    Erzeugt eine A4-Seite mit Standblaettern im PDF-Format";
      print "\t plo rangh: Erzeugt die Rangliste im XHTML 1.0 - Format";
      print "\t plo rangp: Erzeugt die Rangliste im PDC - Format";
      print "\t plo werth: Erzeugt die Wertpunktetabelle im XHTML 1.0 - Format";
      print "\t plo wertp: Erzeugt die Wertpunktetabelle im PDC - Format";
    }
    else if ($1 ~ /plo/ && $2 ~ /kontr/)
      kontrolle(1);
    else if ($1 ~ /plo/ && $2 ~ /st/)
      standblatt();
    else if ($1 ~ /plo/ && $2 ~ /rangh/)
      html_rangliste();
    else if ($1 ~ /plo/ && $2 ~ /rangp/)
      pdc_rangliste();
    else if ($1 ~ /plo/ && $2 ~ /werth/)
      html_wertpunkte();
    else if ($1 ~ /plo/ && $2 ~ /wertp/)
      pdc_wertpunkte();
    else if ($1 ~ /usage/ || $1 ~ /help/)
      print usage;
    else if ($1 ~ /^$/) 
      ;
    else {
      print "\n...submitting command to operating system...\n";
      system($0);
    }
  } while ($1 != "exit");
}

