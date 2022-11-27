#!/bin/bash
# TODO
# Try using getopt

# What this script does
# xxd -p -c1 testxxd | tr [:lower:] [:upper:]
# add % to beggining of each line
# then remove the \n
# use curl or lynx to 
# https://t1.translatedict.com/1.php?p1=zh-TW&p2=en&p3= HERE
# output that to a new file

dataProcessing() {
	convertedFile+=$(echo "$line"| xxd -p -c1 | tr [:lower:] [:upper:] | sed 's/^/\%/g' | tr -d '\n')
	charCount=$(echo "${#convertedFile}")
}

translation() {
	links=$(echo "https://t1.translatedict.com/1.php?p1=$sourceLang&p2=$targetLang&p3=$convertedFile")
	echo -ne "\r$fileName | $charCount "
	curl -s "$links" >> $finalFileName
	convertedFile=''
}

# Chinese Traditional = TW
# Chinese Simplified = zh
# Japanese = ja
# English = en
# Indonesian = id
# Autodetect source lang = auto
fileName=$( basename $1 .txt)
targetLang="en"
sourceLang="auto"
finalFileName="$fileName-Translated.txt"
textLengthMax="4000"
echo " " >> $finalFileName
echo "$fileName" >> $finalFileName
while IFS= read -r line
do
	dataProcessing
	if [ "$charCount" -gt $textLengthMax ]; then
		translation
	fi
done < "$1"
translation
echo "$fileName is Done! | $charCount"
