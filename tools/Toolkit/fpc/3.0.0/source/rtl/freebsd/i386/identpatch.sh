#!/bin/sh
elfdump -n `which elfdump` |awk '/FreeBSD/{print $2}' >elfversion
IDVERSION=`cat elfversion`
rm elfversion
echo Patching cprt0.as with version $IDVERSION

sed -I.sav -es/900044/$IDVERSION/ cprt0.as
sed -I.sav -es/900044/$IDVERSION/ dllprt0.as
sed -I.sav -es/900044/$IDVERSION/ prt0.as
sed -I.sav -es/900044/$IDVERSION/ si_c.inc
sed -I.sav -es/900044/$IDVERSION/ si_prc.inc

