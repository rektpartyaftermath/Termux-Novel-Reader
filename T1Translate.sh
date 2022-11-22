#!/bin/bash
# What this script does
# xxd -p -c1 testxxd | tr [:lower:] [:upper:]
# add % to beggining of each line
# then remove the \n
# use curl or lynx to 
# https://t1.translatedict.com/1.php?p1=zh-TW&p2=en&p3= HERE
# output that to a new file
fileName=$( basename $1 .txt)
while IFS= read -r line
do
	convertedFile+=$(echo "$line"| xxd -p -c1 | tr [:lower:] [:upper:] | sed 's/^/\%/g' | tr -d '\n')
	charCount=$(echo "${#convertedFile}")
	if [ "$charCount" -gt 4000 ]
	then
	#	Chinese Traditional
	#	links=$(echo "https://t1.translatedict.com/1.php?p1=zh-TW&p2=en&p3=$convertedFile")

	#	Chinese Simplified
	#	links=$(echo "https://t1.translatedict.com/1.php?p1=zh&p2=en&p3=$convertedFile")

	#	Japanese
	#	links=$(echo "https://t1.translatedict.com/1.php?p1=ja&p2=en&p3=$convertedFile")

	#	Auto Detect
		links=$(echo "https://t1.translatedict.com/1.php?p1=auto&p2=en&p3=$convertedFile")
		
	#	w3m -dump  \'$links\' >> result.txt
	#	lynx -dump -width=5000 -nolist $links | sed 's/\.\ /\.\n/g'	>> $fileName\-Translated.txt
		echo -ne "\rProcessing $fileName charCount $charCount "
		curl -s "$links" >> $fileName\-Translated.txt
		convertedFile=''
	fi
done < "$1"
	links=$(echo "https://t1.translatedict.com/1.php?p1=auto&p2=en&p3=$convertedFile")
	curl -s "$links" >> $fileName\-Translated.txt
echo "$fileName is Done! With remainder of $charCount"
