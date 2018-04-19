#!/bin/bash

# 1. run dlpdflist.sh - get list of PDFs from google
# 2. run dlprotocols.sh - download PDFs
# 3. run parseprotocols.sh - convert PDFs to text
# 4. run protocoltodata.py - output csv files


if [ "a"$1 = "a" ] ; then
	echo "Usage: parseprotocols.sh <searchstring>"
	exit 0
fi

season=$1

for filename in ../protocols/$season/*.pdf; do

filehandle=`echo $filename | awk -F. '{ print $1 ; }'`

echo $filename

pdftotext -layout $filename > $filehandle.txt
sed -i '' 's/  */ /g' $filehandle.txt
sed -i '' '/^$/d' $filehandle.txt

done
