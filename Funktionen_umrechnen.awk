#########################################################################################
#
# Funktionen_umrechnen V2.0.4   17.10.2018
#
# Autor: Adrian Boehlen
#
# Modul enthaelt Funktionen zum Umrechnen der Resultate in Prozentwerte
#
#########################################################################################

# Den Resultaten wird der Zuschlag addiert (falls gesetzt), anschliessend
# wird der Wert in Prozente zum Maximum umgerechnet und auf 3 Stellen gerundet.

# OP
function proz_op(op_r, op_z,    op_p) {
  op_p = (op_r + op_z) * 100 / maximum["op"];
  return sprintf("%.3f", op_p);
}  

# FS / VFS
function proz_fs(fs_r, fs_z,    fs_p) {
  fs_p = (fs_r + fs_z) * 100 / maximum["fs"];
  return sprintf("%.3f", fs_p);
}  

# Grauholz
function proz_gr(gr_r, gr_z,    gr_p) {
  gr_p = (gr_r + gr_z) * 100 / maximum["gr"];
  return sprintf("%.3f", gr_p);
}  

# Maerz
function proz_mar(mar_r, mar_z,    mar_p) {
  mar_p = (mar_r + mar_z) * 100 / maximum["mar"];
  return sprintf("%.3f", mar_p);
}  

# EWS Feld A
function proz_ews_a(ews_r, ews_z,    ews_p) {
  ews_p = (ews_r + ews_z) * 100 / maximum["ews_a"];
  return sprintf("%.3f", ews_p);
}  

# EWS Feld D / E
function proz_ews_de(ews_r, ews_z,    ews_p) {
  ews_p = (ews_r + ews_z) * 100 / maximum["ews_de"];
  return sprintf("%.3f", ews_p);
}  

# Minger
function proz_mi(mi_r, mi_z,    mi_p) {
  mi_p = (mi_r + mi_z) * 100 / maximum["mi"];
  return sprintf("%.3f", mi_p);
}  

# Off. Anlass
function proz_hv(hv_r, hv_z,    hv_p) {
  hv_p = (hv_r + hv_z) * 100 / maximum["hv"];
  return sprintf("%.3f", hv_p);
}  

# Vancouver
function proz_van(van_r, van_z,    van_p) {
  van_p = (van_r + van_z) * 100 / maximum["van"];
  return sprintf("%.3f", van_p);
}  

# Bubenberg
function proz_bub(bub_r, bub_z,    bub_p) {
  bub_p = (bub_r + bub_z) * 100 / maximum["bub"];
  return sprintf("%.3f", bub_p);
}  

# Sektion
function proz_sek(sek_r, sek_z,    sek_p) {
  sek_p = (sek_r + sek_z) * 100 / maximum["sek"];
  return sprintf("%.3f", sek_p);
}  

# Standstich
function proz_st(st_r, st_z,    st_p) {
  st_p = (st_r + st_z) * 100 / maximum["st"];
  return sprintf("%.3f", st_p);
}  

# Schnellstich
function proz_sch(sch_r, sch_z,    sch_p) {
  sch_p = (sch_r + sch_z) * 100 / maximum["sch"];
  return sprintf("%.3f", sch_p);
}  

# Kunststich
function proz_kun(kun_r, kun_z,    kun_p) {
  kun_p = (kun_r + kun_z) * 100 / maximum["kun"];
  return sprintf("%.3f", kun_p);
}  

