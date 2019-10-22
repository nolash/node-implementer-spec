#!/usr/bin/bash

srcfile=$1
dstfile=$2
created=$(date +%Y-%m-%d | tr "\n" " " | sed -e 's/ //')
serial="<To be assigned>"
title="Swarm node implementer spec - "
if [ -f $2 ]; then
	created=$(grep -e "^created: " $2 | awk '{print $2}')
	serial=$(grep -e "^SWIP: " $2 | awk -F ": " '{print $2}')
	title=$(grep -e "^title: " $2 | awk -F ": " '{print $2}')
fi

cat SWIP-formal-header.md | awk "{ if (/^created: /) { print \$1 \" ${created}\" } else if (/^title: /) { print \$1 \" ${title}\" } else if (/^SWIP: /) { print \$1 \" ${serial}\" } else { print \$0 } }" > $2
cat $1 | sed -e 's/^#/##/' >> $2
cat SWIP-formal-footer.md >> $2
