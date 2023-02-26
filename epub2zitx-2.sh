#!/bin/bash
# Epub2txt-dir, simple script to convert epub to raw txt
# Then place them on a directory with a same file name
# Experimental script, need more testing.
tmploc=~/tmp/epubketeks
unzip -j "$1" "*html*" -d $tmploc
listfilinput=$tmploc/list.txt
ls $tmploc/*html | sort -V > $listfilinput
fitarget=$(basename "$1" .epub)
mkdir ./$fitarget
textwidth=2000
total=$(wc -l < $listfilinput)
now=1
chapCounter=1
clear
while IFS= read -r line
do
	resultName="./$fitarget/Chapter-$chapCounter.txt"
	currentFileSize=$(stat --printf="%s" $line)
	if [ "$currentFileSize" -gt 1400 ]
	then
		w3m -dump -cols $textwidth $line > $resultName
	fi
	rm $line
	now=$counter\00
	percent=$(( "$now" / "$total" ))
	echo -ne "\r$percent%"
	((counter++))
	((chapCounter++))
done < "$listfilinput"
echo -ne "\r100%\nDone!"
zip -j -m -9 "$fitarget"\.zitx ./"$fitarget"/Chapter-*
rm -d ./"$fitarget"
rm $listfilinput
