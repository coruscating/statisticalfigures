#!/bin/bash

# 1. run dlpdflist.sh - get list of PDFs from google
# 2. run dlprotocols.sh - download PDFs
# 3. run parseprotocols.sh - convert PDFs to text
# 4. run protocoltodata.py - output csv files


# Scrapes list of PDFs from google results
# number of pages determined from:
# <div class="sd" id="resultStats">About 244 results</div>
# Note: google doesn't like it when you curl so you might have to end up doing it manually

if [ "a"$1 = "a" ] ; then
	echo "Usage: dlpdflist.sh <searchstring>"
	exit 0
fi

echo "Fetching page 1"
curl -k -sA "Chrome" -L 'https://www.google.com/search?q=site%3Aisuresults.com+http%3A%2F%2Fwww.isuresults.com%2Fresults%2F'$1'+filetype%3Apdf&num=100' -o search.html
grep -o "http://www.isuresults.com/results/$1[a-zA-Z0-9/_]*\.pdf" search.html | uniq | grep -vi time > pdflist

res=`grep -o 'resultStats">'".*results</div>" search.html | awk '{ print $(NF-1) ; }'`
echo res=$res
pages=`expr $res / 100 + 1`
pagenum=2
echo $pages
echo pagenum=$pagenum


while [ $pages -ge $pagenum ] ; do
	echo "Fetching page $pagenum"
	let start="($pagenum - 1) * 100"
	curl -k -sA "Chrome" -L 'https://www.google.com/search?q=site%3Aisuresults.com+http%3A%2F%2Fwww.isuresults.com%2Fresults%2F'$1'+filetype%3Apdf&num=100&start='$start -o search$pagenum.html
	grep -o "http://www.isuresults.com/results/$1[a-zA-Z0-9/_]*\.pdf" search$pagenum.html | uniq | grep -vi time >> pdflist
	pagenum=`expr $pagenum + 1`
done

#cat pdflist

echo "Done"

#rm search.html