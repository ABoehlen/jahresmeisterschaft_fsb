function parameter() {

#########################################################################################
#
# Parameter V2.0.2  08.12.2019
#
# Autor: Adrian Boehlen
#
# Modul definiert verschiedene Parameter
#
#########################################################################################

# Dictionary der Maxima der einzelnen Schiessprogramme
# Grundlage EWS: http://www.swissshooting.ch/desktopdefault.aspx/tabid-189/236_read-5154/

maximum["op"] =      85; # Obligatorisches Programm
maximum["fs"] =      72; # Feldschiessen
maximum["gr"] =      60; # Grauholzschiessen
maximum["mar"] =    100; # Maerzschiessen
maximum["ews_a"] =  200; # Einzelwettschiessen Feld A
maximum["ews_de"] = 150; # Einzelwettschiessen Feld D und E
maximum["mi"] =      40; # Mingerschiessen
maximum["hv"] =     100; # Sektionsstich am von der HV bestimmten Anlass
maximum["van"] =    100; # Vancouverstich
maximum["bub"] =    100; # Bubenbergschiessen
maximum["sek"] =     40; # Sektionsstich der Jahresmeisterschaft
maximum["st"] =     100; # Standstich
maximum["sch"] =     40; # Schnellstich
maximum["kun"] =    500; # Kunststich



# Dictionary der Gutpunkte pro Kategorie pro Rang gemaess Reglement
# Grundlage: Reglement Jahresmeisterschaft, 05.02.2015

gutpunkt["A1"] =  25; # Kategorie A, Rang 1
gutpunkt["A2"] =  15; # Kategorie A, Rang 2
gutpunkt["A3"] =  10; # Kategorie A, Rang 3
gutpunkt["A4"] =   8; # Kategorie A, Rang 4
gutpunkt["A5"] =   8; # Kategorie A, Rang 5
gutpunkt["A6"] =   8; # Kategorie A, Rang 6
gutpunkt["A7"] =   5; # Kategorie A, Rang 7
gutpunkt["A8"] =   5; # Kategorie A, Rang 8
gutpunkt["A9p"] =  5; # Kategorie A, Rang 9 und hoeher
gutpunkt["B"] =    5; # Kategorie B, alle Raenge



# Dictionary der Zuschlaege fuer Jungschuetzen
# Grundlage: Reglement Jahresmeisterschaft, 05.02.2015 und Vorstandsbeschluesse

zuschlag["op"] =   2; # Obligatorisches Programm
zuschlag["vfs"] =  2; # Voruebung Feldschiessen
zuschlag["fs"] =   2; # Feldschiessen
zuschlag["gr"] =   1; # Grauholzschiessen
zuschlag["mar"] =  1; # Maerzschiessen
zuschlag["ews"] =  1; # Einzelwettschiessen alle Felder
zuschlag["mi"] =   1; # Mingerschiessen
zuschlag["hv"] =   1; # Sektionsstich am von der HV bestimmten Anlass
zuschlag["van"] =  2; # Vancouverstich
zuschlag["bub"] =  1; # Bubenbergschiessen
zuschlag["sek"] =  1; # Sektionsstich der Jahresmeisterschaft
zuschlag["st"] =   2; # Standstich
zuschlag["sch"] =  1; # Schnellstich
zuschlag["kun"] = 10; # Kunststich



# Dictionary der Bonus und Maluswerte
# Grundlage: Reglement Jahresmeisterschaft, 05.02.2015

bonus_malus["A"] = 9; # Kategorie A: Bonus/Malus: 9 Prozentpunkte
bonus_malus["B"] = 6; # Kategorie B: Bonus/Malus: 6 Prozentpunkte

}
