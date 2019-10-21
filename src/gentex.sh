#!/bin/bash

if [ ! -z $1 ]; then
	>&2 echo "generating ${1}.tex"
	cp $1 ${1}.tex
	sh links.sh ${1}.tex 
	exit 0
fi

rm -v *.latex.tex
for i in ./*.latex; do
	cp $i ${i}.tex 
	sh links.sh ${i}.tex 
done