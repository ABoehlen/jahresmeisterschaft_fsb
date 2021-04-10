#########################################################################################
#
# Funktionen_erfassen V2.0.6   24.10.2018
#
# Autor: Adrian Boehlen
#
# Modul enthaelt Funktionen zum Erfassen der Resultate
#
#
# als Parameter uebernommen werden die Alterskategorie und das Resultat
# zusaetzlich eingelesen wird, ob ein Kranzresultat vorliegt oder nicht
# berechnet werden die vom Vorstand bewilligten Zuschlaege
# zurückgeliefert wird ein konkatenierter String mit folgenden Informationen:
#   Resultat, Prozentwert, Zuschlag, Kranz (sofern moeglich), Feld (nur EWS)
#
#########################################################################################

# OP
function erf_op(kategorie,eingabe,    eing_kr, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "op");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    kr = calc_kranz();
    resultat = eingabe;
    prozent = proz_op(resultat, zuschlag);
    return resultat " " prozent " " zuschlag " " kr;
  }
}

# VFS
function erf_vfs(kategorie,eingabe,    prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "vfs");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    resultat = eingabe;
    prozent = proz_fs(resultat, zuschlag);
    return resultat " " prozent " " zuschlag;
  }
}

# FS
function erf_fs(kategorie,eingabe,    eing_kr, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "fs");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    kr = calc_kranz();
    resultat = eingabe;
    prozent = proz_fs(resultat, zuschlag);
    return resultat " " prozent " " zuschlag " " kr;
  }
}

# Grauholz
function erf_gr(kategorie,eingabe,    eing_kr, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "gr");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    kr = calc_kranz();
    resultat = eingabe;
    prozent = proz_gr(resultat, zuschlag);
    return resultat " " prozent " " zuschlag " " kr;
  }
}

# Maerzschiessen
function erf_mar(kategorie,eingabe,    eing_kr, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "mar");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    kr = calc_kranz();
    resultat = eingabe;
    prozent = proz_mar(resultat, zuschlag);
    return resultat " " prozent " " zuschlag " " kr;
  }
}

# Einzelwettschiessen
function erf_ews(kategorie,eingabe,    eing_kr, feld, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "ews");
  if (eingabe == 0)
    return 0 " " 0 " " 0 " " 0 " " "n_a"; # wegen zusaetzlichem Element "Feld"
  else {
    do {
      printf("\tFeld: ");
      getline feld;
    } while (feld !~ /^a$|^d$|^e$/);
    kr = calc_kranz();
    resultat = eingabe;
    if (feld == "a")
      prozent = proz_ews_a(resultat, zuschlag);
    else if (feld ~ /[de]/)
      prozent = proz_ews_de(resultat, zuschlag);
    else {
      print "Fehler in \"Funktionen_erfassen.awkm\"";
      return;  # darf nicht vorkommen
    }
    return resultat " " prozent " " zuschlag " " kr " " feld;
  }
}

# Minger
function erf_mi(kategorie,eingabe,    eing_kr, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "mi");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    kr = calc_kranz();
    resultat = eingabe;
    prozent = proz_mi(resultat, zuschlag);
    return resultat " " prozent " " zuschlag " " kr;
  }
}

# Offizieller, von der HV bestimmter Anlass
function erf_hv(kategorie,eingabe,    eing_kr, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "hv");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    kr = calc_kranz();
    resultat = eingabe;
    prozent = proz_hv(resultat, zuschlag);
    return resultat " " prozent " " zuschlag " " kr;
  }
}

# Vancouverstich
function erf_van(kategorie,eingabe,    eing_kr, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "van");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    kr = calc_kranz();
    resultat = eingabe;
    prozent = proz_van(resultat, zuschlag);
    return resultat " " prozent " " zuschlag " " kr;
  }
}

# Bubenbergschiessen
function erf_bub(kategorie,eingabe,    eing_kr, kr, prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "bub");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    kr = calc_kranz();
    resultat = eingabe;
    prozent = proz_bub(resultat, zuschlag);
    return resultat " " prozent " " zuschlag " " kr;
  }
}

# Sektionsstich
function erf_sek(kategorie,eingabe,    prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "sek");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    resultat = eingabe;
    prozent = proz_sek(resultat, zuschlag);
    return resultat " " prozent " " zuschlag;
  }
}

# Standstich
function erf_st(kategorie,eingabe,    prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "st");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    resultat = eingabe;
    prozent = proz_st(resultat, zuschlag);
    return resultat " " prozent " " zuschlag;
  }
}

# Schnellstich
function erf_sch(kategorie,eingabe,    prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "sch");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    resultat = eingabe;
    prozent = proz_sch(resultat, zuschlag);
    return resultat " " prozent " " zuschlag;
  }
}

# Kunststich
function erf_kun(kategorie,eingabe,    prozent, resultat, zuschlag) {
  zuschlag = calc_zuschlag(kategorie, "kun");
  if (eingabe == 0)
    return keine_teilnahme();
  else {
    resultat = eingabe;
    prozent = proz_kun(resultat, zuschlag);
    return resultat " " prozent " " zuschlag;
  }
}

