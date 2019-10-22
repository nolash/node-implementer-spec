#!/bin/bash

# helper script for swipmake.sh
# Converts latex citations to footnotes that can be handled by pandoc

b='spec.bib'
f=$1
searching=1
lines=0
block=()
blockkeys=()
blocknum=0
currentblock=()
while read l; do # how to preserve the backslash here?
	if [ $searching -ne 0 ]; then
		if [[ "$l" =~ ^@[a-z]*\{ ]]; then
			searching=0
		fi
	else
		if [[ "$l" =~ ^\} ]]; then
			block[$blocknum]=$(echo ${currentblock[@]})
			blocknum=$(($blocknum+1))
			lines=0
			searching=1
			currentblock=()
		else
			if [[ "$l" =~ ^[[:blank:][:alpha:]]*= ]]; then
				c=""
				r=`expr "$l" : '.*={\(.*\)}.*'`
				if [ $lines -gt 0 ]; then
					c=","
				fi
				currentblock[$lines]="$r$c"
				lines=$(($lines+1))
			else
				r=`expr "$l" : '\([A-Z0-9\:]*\),$'`
				blockkeys[$blocknum]=$r
			fi
		fi
	fi
done < "$b"

OIFS=$IFS
IFS=$(printf '\n')
c=0
for k in ${blockkeys[@]}; do
	v=${block[c]}
	v=$(echo $v | sed -e 's/\//\\\//g') # remove forward slashes in bibliography value
	r="s/\\\\cite{$k}/\\\\footnote{$v}/" # convert to footnote (we discard the square bracket comment for now
	sed $f -i -e "$r" # do the substitution
	r="s/\\\\cite\[.*\]{$k}/\\\\footnote{$v}/" # convert to footnote (we discard the square bracket comment for now
	sed $f -i -e "$r" # do the substitution
	c=$(($c+1)) # next, please
done
IFS=$OIFS
