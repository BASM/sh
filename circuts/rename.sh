#!/bin/sh
set -e
echo "Rename screipt"


PRJ=$1
#PRJ="max232"

if [ "$PRJ" = "" ] ; then
  echo "BAD"
  exit 0
fi

set -x
rm -Rf "$PRJ"
mkdir $PRJ

cp $PRJ-F_Cu.pho      $PRJ/$PRJ.GTL
cp $PRJ-B_Cu.pho      $PRJ/$PRJ.GBL
cp $PRJ-F_Mask.pho    $PRJ/$PRJ.GTS
cp $PRJ-B_Mask.pho    $PRJ/$PRJ.GBS
cp $PRJ-F_SilkS.pho   $PRJ/$PRJ.GTO
cp $PRJ-B_SilkS.pho   $PRJ/$PRJ.GBO
cp $PRJ.drl           $PRJ/$PRJ.TXT
cp $PRJ-Edge_Cuts.pho $PRJ/$PRJ.GKO

rm $PRJ.zip
zip -r $PRJ.zip $PRJ

#cp $PRJ-Front.gtl $PRJ/$PRJ.GTL
#cp $PRJ-Back.gbl  $PRJ/$PRJ.GBL
#cp $PRJ-F_Paste.gtp $PRJ/$PRJ.GTS
#cp $PRJ-B_Paste.gbp $PRJ/$PRJ.GBS
#cp $PRJ-F_SilkS.gto $PRJ/$PRJ.GTO
#cp $PRJ-B_SilkS.gbo $PRJ/$PRJ.GBO
#cp $PRJ.drl $PRJ/$PRJ.TXT


