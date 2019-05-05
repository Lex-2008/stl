#!/bin/bash

if test "$#" != "3"; then
	echo "$0 <template> <list> <pages>"
	exit 1
fi

TEMPLATE="$1"
LIST="$2"
PAGES="$3"
NL="
"


while read name tags; do
	echo "building [$name.html]..."
	tags1="$( echo "$name" | tr '/-' '\n' )"
	tags2="$( echo "$tags" | tr ' ' '\n' )"
	sedname="$( echo "$name" | tr '/' '-' )"
	tags="$( echo "all$NL$sedname$NL$tags1$NL$tags2" | sort -u | sed '/^$/d')"
	sed="$(echo "$tags" | sed 's_.*_/<!-- begin & -->/,/<!-- end & -->/p;/<!-- for & -->/p_')"
	test -f "$PAGES/$name.html" && sed="$sed;$NL/<!-- main content -->/r $PAGES/$name.html"
	sed -n "$sed" "$TEMPLATE" >"$name.html"
done <"$LIST"
