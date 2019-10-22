#!/bin/bash

# helper script for swipmake.sh
# Changes ANBF listings to markdown tables, as requested by SWIP reviewers

f=$1
searching=1
buf=()

OIFS=$IFS
IFS=$(printf '\n')
c=0
while read l; do
	if [[ "$l" =~ ^[[:space:][:space:][:space:][:space:]].*=.* ]]; then
		if [ $searching -ne 0 ]; then
			>&2 echo "starting new on $l"
			searching=0
		fi
		k=`expr "$l" : '^    \([[:alnum:]]*\) .*'`
		if [ ! -z "$k" ]; then
			v=`expr "$l" : '.*= \(.*\)$'`
			buf[$c]="| $k | $v |"
			c=$(($c+1))
		fi
	elif [ "$searching" -eq 0 ]; then
		echo "| id | def |"
		echo "| :--- | :---- |"
		for e in ${buf[@]}; do
			echo $e
		done
		echo
		buf=()
		searching=1
		c=0
	else
		echo $l
	fi	
done < $f
IFS=$OIFS
