#!/bin/bash

# helper script for swipmake.sh
# converts cross-chapter references to actual github repository links
# database swipdb.txt must be manually maintained, as swip numbers are assigned manually
# database format (separated by spaces):
# <file stem name> <repository> <branch> <swip number>
# file stem name must match the variable part of the swip file name, either swip-<file stem name> or swip-<swip number>-<file stem name>.md

f=$1

OIFS=$IFS
IFS_NL=$(printf '\n')
IFS=$IFS_NL
sedcmds=()
crsr=0
while read l; do
	sedcmd=`echo -n $l | awk '{print "s/\\\[\\\[" $1 "\\\]\\\](#.*)/[" $1 "](https:\\\/\\\/github.com\\\/" $2 "\\\/tree\\\/" $3 "\\\/SWIPs\\\/swip-" $1 ".md)/"}'`
	swipno=`expr "$l" : '.* \([[:digit:]]*\)$'`
	if [ $swipno -ne 0 ]; then
		sedcmds[$crsr]=${sedcmd/swip-/swip-$swipno-}
	else
		sedcmds[$crsr]=$sedcmd
	fi
	crsr=$(($crsr+1))
done < swipdb.txt

for c in ${sedcmds[@]}; do
	echo "sed $f -i -e $c"
	$(sed $f -i -e $c)
done

IFS=$OIFS
