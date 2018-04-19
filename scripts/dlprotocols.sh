#!/bin/bash

# 1. run dlpdflist.sh - get list of PDFs from google
# 2. run dlprotocols.sh - download PDFs
# 3. run parseprotocols.sh - convert PDFs to text
# 4. run protocoltodata.py - output csv files

if [ "a"$1 = "a" ] ; then
	echo "Usage: dlprotocol.sh <searchstring>"
	exit 0
fi

season=$1

cd protocols/$season

# get the competitions

array=("Men_SP" "Men_FS" "Ladies_SP" "Ladies_FS" "Pairs_SP" "Pairs_FS" "IceDance_SD" "IceDance_FD" "JuniorMen_SP" "JuniorMen_FS" "JuniorLadies_SP" "JuniorLadies_FS" "JuniorPairs_SP" "JuniorPairs_FS" "JuniorIceDance_SD" "JuniorIceDance_FD")

for k in `grep -o ../$season/.*/ pdflist | sort | uniq | awk -F'/' '{ print $(NF-1) ; }'`; do
	echo k=$k
	for i in "${array[@]}"; do   # The quotes are necessary here
	    echo $k"_"$i".pdf"
	    wget -w 1 --random-wait "http://www.isuresults.com/results/$season/"$k"/"$k"_"$i"_Scores.pdf"
	done
done