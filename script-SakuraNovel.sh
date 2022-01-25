#!/bin/bash
# berkas txt yg isinya link tiap chapter
counter=1
input=./list-final.txt
# ga paham klo yg ini
while IFS= read -r line
do
	# dump pake lynx -nolist biar ga ada link
	lynx -dump -nolist -width=50 $line | sed -e 's/^[ \t]*//' | sed -n '21,/Comments\ for\ chapter/p' >> result.txt
	# biar keliatan bersih
	clear
	# nampilin chapter yg dah di dump
	echo "Chapter-$counter Done!"
	((counter++))
done < "$input"
echo "Book Name:"
read book
mv result.txt $book.txt
