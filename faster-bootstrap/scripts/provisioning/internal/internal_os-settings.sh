#!/bin/sh

# Change localtime
# Modiy this with your Timezone

# ls /usr/share/zoneinfo/
# Africa      Australia  Cuba     Etc      GMT-0      Indian       Kwajalein  Navajo    posix       ROK        UTC
# America     Brazil     EET      Europe   GMT+0      Iran         Libya      NZ        posixrules  Singapore  WET
# Antarctica  Canada     Egypt    GB       Greenwich  iso3166.tab  MET        NZ-CHAT   PRC         Turkey     W-SU
# Arctic      CET        Eire     GB-Eire  Hongkong   Israel       Mexico     Pacific   PST8PDT     UCT        zone1970.tab
# Asia        Chile      EST      GMT      HST        Jamaica      MST        Poland    right       Universal  zone.tab
# Atlantic    CST6CDT    EST5EDT  GMT0     Iceland    Japan        MST7MDT    Portugal  ROC         US         Zulu

sudo ln -sf  /usr/share/zoneinfo/Japan /etc/localtime
