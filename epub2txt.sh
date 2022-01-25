#!/bin/bash
# Epub2txt, simple script to convert epub to raw txt
# Experimental script, need more testing.
tmploc=~/tmp/epubketeks
unzip -j "$1" "*html*" -d $tmploc
listfilinput=$tmploc/list.txt
ls $tmploc/*html | sort -V > $listfilinput
fitarget=$(basename "$1" .epub)
if [ "$2" == "-lw" ]
then
	textwidth=1000
else
	textwidth=65
fi
total=$(wc -l < $listfilinput)
now=1
clear
while IFS= read -r line
do
	w3m -dump -cols $textwidth $line >> "$fitarget"\.txt 
	rm $line
	now=$counter\00
	percent=$(( "$now" / "$total" ))
	echo -ne "\r$percent%"
	((counter++))
done < "$listfilinput"
echo -ne "\r100%\nDone!"
rm $listfilinput
