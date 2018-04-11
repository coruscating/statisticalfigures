#!/bin/bash

# Run this before running protocoltodata.py to generate text files from PDF protocols

for filename in protocols/season1718/*.pdf; do

filehandle=`echo $filename | awk -F. '{ print $1 ; }'`

pdftotext -layout $filename > $filehandle.txt
sed -i '' 's/  */ /g' $filehandle.txt
sed -i '' '/^$/d' $filehandle.txt

done
