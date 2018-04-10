# Statistical Figures

Data science meets the ice.

## Instructions

1. Score PDFs need to be downloaded from the ISU website. Here's one way to use Google to crawl for pdfs:

```
site:isuresults.com http://www.isuresults.com/results/season1718 filetype:pdf
```

2. Download the Google results HTML and search for score PDFs by excluding time schedules:

```
grep -o "http://www.isuresults.com/results/season1718[a-zA-Z0-9/_]*\.pdf" google_1718 | uniq | grep -vi time > pdflist
```

3. Batch download protocols with `wget`:

```
wget -i pdflist
```

4. Run `parseprotocol.sh` to make files suitable for feeding into `protocoltodata.py`.

5. Run `protocoltodata.py` to generate two csv files.

## Format

`agg_elems.csv` has one line per element and `agg_scores.csv` has one line per program. These are the possible fields:

```
comp: (from filename, lowercased)
year: 2018
discp: 0=Men, 1=Ladies
seg: 0=SP, 1=FP
skname: first name LAST NAME
nat: 3 letter nation code as written in the protocols
rank: rank in this segment
order: starting order
tss: total segment score
tes: total element score
tpcs: total PCS (factored)
tded: total deductions
bl: element backloaded (0=no, 1=yes)
dg: element downgraded << (0=no, 1=yes)
ur: element underrotated < (0=no, 1=yes)
ue: element unclear edge ! (0=no, 1=yes)
we: element wrong edge e (0=no, 1=yes)
iv: element invalid * (0=no, 1=yes)

```

## Notes

-Olympics, GPF, and NHK Trophy PDFs were renamed by hand due to different naming conventions.

## To-do

-Do previous seasons
-Add Pairs and Dance
-Add a table for competitions with judge info and other stuff
-Dump stuff into database
