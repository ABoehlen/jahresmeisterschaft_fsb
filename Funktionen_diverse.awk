#########################################################################################
#
# Funktionen_diverse V2.1.3   12.04.2021
#
# Autor: Adrian Boehlen
#
# Modul enthaelt diverse Funktionen zum Jahresmeisterschafts-Programm
#
#########################################################################################


########## berechnet das Total aus OP und FS ##########

function calc_opfs() {
  db_einlesen(dbfile);

  print "*********************************************";
  print "Schuetze                      OP   FS   Total";
  print "*********************************************";

  for (comb in teilnehmer) {
    split(comb, sep, SUBSEP);
    if (sep[1] == "schuetze") {
      printf("%25s     %2d + %2d = %3d\n", teilnehmer["schuetze", sep[2]], teilnehmer["op_r", sep[2]],\
      teilnehmer["fs_r", sep[2]], teilnehmer["op_r", sep[2]] + teilnehmer["fs_r", sep[2]]);
    }
  }
}


########## liefert die bewilligten Zuschlaege zurueck ##########

function calc_zuschlag(kategorie, schiessen) {
  if (kategorie == "j") {
    if (schiessen == "op")
      return zuschlag["op"];
    if (schiessen == "vfs")
      return zuschlag["vfs"];
    if (schiessen == "fs")
      return zuschlag["fs"];
    if (schiessen == "gr")
      return zuschlag["gr"];
    if (schiessen == "mar")
      return zuschlag["mar"];
    if (schiessen == "ews")
      return zuschlag["ews"];
    if (schiessen == "mi")
      return zuschlag["mi"];
    if (schiessen == "hv")
      return zuschlag["hv"];
    if (schiessen == "van")
      return zuschlag["van"];
    if (schiessen == "bub")
      return zuschlag["bub"];
    if (schiessen == "sek")
      return zuschlag["sek"];
    if (schiessen == "st")
      return zuschlag["st"];
    if (schiessen == "sch")
      return zuschlag["sch"];
    if (schiessen == "kun")
      return zuschlag["kun"];
    else {
      print "Fehler in \"Funktionen_diverse.awk\"";
      return 0;  # darf nicht vorkommen
    }
  }
  else
    return 0;
}


########## liefert die korrekten Werte, wenn kein Resultat vorliegt ##########

function keine_teilnahme(    resultat, prozent, zuschlag, kr) {
  resultat = 0;
  prozent = 0;
  zuschlag = 0;
  kr = 0;
  return resultat " " prozent " " zuschlag " " kr;  
}


########## liefert den korrekten Wert, ob ein Kranz geschossen wurde oder nicht ##########

function calc_kranz(    eing_kr, kr) {
  do {
    printf("\tKranz? (j/n) ");
    getline eing_kr;
  } while (eing_kr !~ /^j$|^y$|^n$/);
  return eing_kr ~ /[jy]/ ? kr = 1 : kr = 0;
}


########## prueft, ob ein Resultat vorliegt oder nicht ##########

function res(resultat) {
  return resultat == 0 ? 0 : 1;
}


########## liest CSV-File in zweidimensionalen Array ein ##########

function db_einlesen(csvfile) {
  FS = ",";
  new(teilnehmer);                     # Array neu anlegen
  t = 0;                               # Teilnehmerzaehler mit 0 initialisieren
  while ((getline < csvfile) > 0) {
    if (t == 0) {                      # Feldbezeichnungen in 1. Zeile einlesen
      for (f = 1; f <= NF; f++)
        fields[f] = $f;                # Feldbezeichnungen in Array einlesen
    }
    else {                             # Datenzeilen einlesen
      for (f = 1; f <= NF; f++) 
        teilnehmer[fields[f], t] = $f; # zweidimensionaler Array aufbauen
    }
    t++;
  }
  close(csvfile);
}

########## erzeugt ein neues, leeres Array oder loescht den Inhalt eines bestehenden ##########

function new(array) {
  split("", array, ":");
}
