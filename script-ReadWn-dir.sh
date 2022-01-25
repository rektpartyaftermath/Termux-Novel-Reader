#!/bin/bash

# Contoh link
# https://www.readwn.com/novel/musashi-of-the-elves_1.html

trap ctrl_c INT
ctrl_c(){
	echo -e "$startchap\n$startchap2\n$jumchap" > ./$bookname/LAST
	exit
}
vibrate(){
	echo -ne "\\a\r"
	echo -ne "\\a\r"
	echo -ne "\\a\r"
	echo -ne "\\a\r"
}

parser(){
	lynx -dump -width=50 -nolist https://googleweblight.com/i?u=$fnlink$startchap.html > temp.txt
	sed -e 's/^[ \t]*//' temp.txt | sed -n '8,/NEXT/p' > $bookname/Chapter-$startchap.txt
	printf "\rChapter-$startchap/$jumchap"
	((startchap++))
}

postprocessing(){
	((startchap--))
	echo "Check all chapter"
	startchap=$startchap2
	while [ $startchap -le $jumchap ]
	do
		if test -f ./$bookname/Chapter-$startchap.txt;
		then
			vibrate
			echo "Chapter $startchap OK!"
			cat ./$bookname/Chapter-$startchap.txt >> $bookname\_chapter\_$startchap2\-$jumchap.txt
		else
			echo "Chapter $startchap Missing"
			echo -e "$startchap\n$startchap2\n$jumchap" > ./$bookname/LAST
			vibrate
			vibrate
			exit
		fi
	((startchap++))
	done
	((startchap--))
#	mv $bookname.txt $bookname\_chapter\_$startchap2\-$startchap.txt
	echo -e "\nBook $bookname Chapter $startchap2-$startchap Completed!"
	rm temp.txt*
}

echo "Link:"
read sourcelink
fnlink=$( echo $sourcelink | sed s/......$// )
bookname=$( echo "$sourcelink" | awk -F"/" '{print $5}' | sed s/.......$// )
if test -f ./$bookname/LAST;
then
	echo "Continue Using last saved position"
	startchap=$( sed -n 1\p ./$bookname/LAST )
	startchap2=$( sed -n 2\p ./$bookname/LAST )
	jumchap=$( sed -n 3\p ./$bookname/LAST )

else
	mkdir $bookname
	echo "Awal mulai:"
	read startchap
	echo "Akhirnya:"
	read jumchap
	if [ "$startchap" -lt "1" ]
	then
		startchap="1"
	fi
	startchap2=$startchap
fi
# echo "Nama Buku:"
# read bookname
lastline=./$bookname/$startchap.txt;
echo "$bookname"
while [ $startchap -le $jumchap ]
do
	parser
done
postprocessing
