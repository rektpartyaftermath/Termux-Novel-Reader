#!/bin/bash
#Simple scirpt to Batch Translate using T1Translate
#Get all file on current simple.sh file location
#with a Chapter-* name
#then pass them 20 by 20 onto T1Translate with xargs
#when done, pack all translated file into 1, with correct numbered name
cutCount=0
cutCount1=0
cutStep=100
fileList=./list.txt
ls ./Chapter-*.txt | sort -V > $fileList
totalFile=$( wc -l < $fileList )
echo $totalFile
while [ $cutCount -lt $totalFile ]
do
	cutCount=$(( "$cutCount" + "$cutStep" ))
	if [ $cutCount1 -eq 0 ];then
		cutCount1=1
	fi
	sed -n $cutCount1,$cutCount\p $fileList > ./cuttersimple.txt
	cat ./cuttersimple.txt | xargs -P $cutStep -n 1 bash /content/T1Translate.sh
	cutCount1=$(( "$cutCount1" + "$cutStep" ))
	echo "done"
done
echo "Start Packing"
ls ./*Translated.txt | sort -V > ./listTrans.txt
resultName="All-Translated.txt"
while IFS= read -r transLine
do
	chapterNum=$(echo "$transLine" | tr -d [:alpha:][:punct:])
	# echo "" >> $resultName
	# echo "Chapter-$chapterNum" >> $resultName
	cat $transLine >> $resultName
done < ./listTrans.txt
echo "All done!"
