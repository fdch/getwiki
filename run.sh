#!/bin/bash

set -e

FORMAT=json

if [[ $1 ]]; then
	TARGET=$1
else
	echo "
usage: provide a Wikipedia title in argument one, e.g.:
./run List_of_English_prepositions
"
	exit 1
fi

./getwiki $TARGET $FORMAT

./py_json $TARGET.$FORMAT $TARGET.temp

if [[ $2 ]] ; then
	perl -ne 'print if /^#/' $TARGET.temp | sed 's/# \[\[wikt://' | cut -d '#' -f 1 | cut -d '|' -f 1 | sed '/^\s*$/d' > $TARGET
else
	perl -ne 'print if /wikt:/'  $TARGET.temp | sed 's/\[\[wikt//' | cut -d ':' -f 2 | cut -d '|' -f 1 | cut -d '#' -f 1 | sed "s/''//" | sed '/^ /d' | sed '/^\s*$/d'  > $TARGET
fi

COUNT=$(wc -w < $TARGET | sed 's/ //g')

if [[ $COUNT -gt "1" ]] ; then
	rm $TARGET.$FORMAT
	rm $TARGET.temp
else
	rm $TARGET
	echo "Nothing was found in $TARGET"
	exit 1
fi

exit 0
