#!/bin/bash

# minizinc already in path
#PATH="/home/dominic/Downloads/minizinc-1.4.3/bin:$PATH"
if [ "$1 " == " " ]; then
  echo "Syntax: $0 <MZN-Datei> [<DZN-Datei]." 1>&2
  echo "Abbruch." 1>&2
  exit 1
fi
if [ ! -f "$1" ]; then
  echo "MZN-Datei $1 nicht gefunden. Abbruch." 1>&2
  exit 1
fi
if [ $# -eq 2 ] && [ ! -f "$2" ]; then
  echo "DZN-Datei $2 nicht gefunden. Abbruch." 1>&2
  exit 1
fi

log="$(pwd)/$(dirname "$1")/$(basename "$1" mzn)$(date +%Y%m%d_%H%M%S).log"
function out() {
	echo $(date "+%d.%m.%Y %H:%M:%S"): $1 | tee -a "$log"
}
out "Starte. Ausgabe in $log"

fzn="$(pwd)/$(dirname "$1")/$(basename "$1" mzn)fzn"
if [ $# -eq 2 ]; then
        out "Generiere fzn-Datei ($fzn) aus $1 und $2 ..."
        mzn2fzn --no-optimise "$1" "$2" -o "$fzn"
else
	out "Generiere fzn-Datei ($fzn) aus $1 ..."
	mzn2fzn --no-optimise "$1" -o "$fzn"
fi

out "Starte Lösung von fzn-Datei mit yices (${MEMORY}M)..."
stamp1=$(date +%s);
cd /apps/fzn2smt-2-0-02/
CLASSPATH=.:/apps/antlr-runtime-3.2.jar java fzn2smt -ce "/apps/yices-2.1.0/bin/yices-smt -f" -i "$fzn" \
  | while read line; do 
	stamp2=$(date +%s);
	echo $line | grep -q "^MT =" && echo "$(date "+%d.%m.%Y %H:%M:%S"), $(($stamp2-$stamp1)) Sekunden:";
	echo "$line";
  done | tee -a "$log"

stamp2=$(date +%s);
out "Yices fertig nach $(($stamp2-$stamp1)) Sekunden."
rm "$fzn"
cd -
exit 0
