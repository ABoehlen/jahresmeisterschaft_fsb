function kontrolle(output,    comb, format) {

#########################################################################################
#
# Kontrolle V2.0.2  08.12.2019
#
# Autor: Adrian Boehlen
#
# Programm dient der Kontrolle der durch Erfassen.awk erzeugten Daten 
# Ausgegeben werden zu jedem Schiessen das Resultat und die Prozente zum Maximum
# Je nachdem, mit welchem Argument das Modul aufgerufen wird, geht der Output
# auf den Bildschirm oder in die Datei 'kontrolle.txt'
#
#########################################################################################

########## Variablen initialisieren ##########

FS = ",";
file = "kontrolle.txt";
format = "%25s (%s) %12s: %3d Pt. %7.3f %%\n";

if (output == 1)
  output = file;
else
  output = "/dev/stdout";

########## DB-File in zweidimensionalen Array einlesen ##########

db_einlesen(dbfile);

########## Daten formatiert ausgeben ##########
  
print "\n*************************************************************"                                                                                        > output;
print "Erfasste Schuetzen"                                                                                                                                     > output;
print "*************************************************************"                                                                                          > output;
 
for (comb in teilnehmer) {
  split(comb, sep, SUBSEP);
  if (sep[1] == "schuetze") {
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "OP", teilnehmer["op_r", sep[2]], teilnehmer["op_p", sep[2]])            > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "VFS", teilnehmer["vfs_r", sep[2]], teilnehmer["vfs_p", sep[2]])         > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "FS", teilnehmer["fs_r", sep[2]], teilnehmer["fs_p", sep[2]])            > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Grauholz", teilnehmer["gr_r", sep[2]], teilnehmer["gr_p", sep[2]])      > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Maerz", teilnehmer["mar_r", sep[2]], teilnehmer["mar_p", sep[2]])       > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Einzelwett.", teilnehmer["ews_r", sep[2]], teilnehmer["ews_p", sep[2]]) > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Minger", teilnehmer["mi_r", sep[2]], teilnehmer["mi_p", sep[2]])        > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Off. Anl.", teilnehmer["hv_r", sep[2]], teilnehmer["hv_p", sep[2]])     > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Bubenberg", teilnehmer["bub_r", sep[2]], teilnehmer["bub_p", sep[2]])   > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Sektion", teilnehmer["sek_r", sep[2]], teilnehmer["sek_p", sep[2]])     > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Stand", teilnehmer["st_r", sep[2]], teilnehmer["st_p", sep[2]])         > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Schnell", teilnehmer["sch_r", sep[2]], teilnehmer["sch_p", sep[2]])     > output;
    printf(format, teilnehmer["schuetze", sep[2]], teilnehmer["kategorie_j", sep[2]], "Kunst", teilnehmer["kun_r", sep[2]], teilnehmer["kun_p", sep[2]])       > output;
    printf("\n")                                                                                                                                               > output;
  }
}
print "*************************************************************"                                                                                          > output;

if (output == file) {
  print "\nTextfile 'kontrolle.txt' wurde erfolgreich angelegt";
  close(output);
}

}

