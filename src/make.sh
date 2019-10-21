#!/usr/bin/env bash

base=$1
if [ ! -f ${base}.latex ]; then
	exit 1;	
fi
sh gentex.sh ${base}.latex

tmp=$(mktemp --suffix=.latex)
>&2 echo tmpfile is ${tmp}
cat header.latex > ${tmp}
cat $base.latex.tex >> ${tmp}
cat footer.latex >> ${tmp}
pandoc -f latex -t gfm ${tmp} > md/${base}.md

unlink ${tmp}
