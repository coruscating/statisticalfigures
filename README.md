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

`agg_elems.csv` has one line per element and `agg_scores.csv` has one line per program.

Common fields:
```
comp: (from filename, lowercased)
year: 2018
discp: 0=Men, 1=Ladies
seg: 0=SP, 1=FP
skname: first name LAST NAME
nat: 3 letter nation code from protocols
```

`agg_elems.csv` fields:
```
elen: element # in program
eles: element description with features and levels removed (3F+2T, StSq)
lvl: element level (for spins and step sequences)
bl: element backloaded (0=no, 1=yes)
dg: element downgraded << (0=no, 1=yes)
ur: element underrotated < (0=no, 1=yes)
ue: element unclear edge ! (0=no, 1=yes)
we: element wrong edge e (0=no, 1=yes)
iv: element invalid * (0=no, 1=yes)
ele: element full description (i.e. 3F<+2T<<, StSq4)
bv: element base value
goe: element total GOE
goejN: element GOE, judge N
ets: element total score
```

`agg_scores.csv` fields:
```
rank: rank in this segment
order: starting order
tss: total segment score
tes: total element score
tpcs: total PCS (factored)
tded: total deductions
tbv: total base value
pcsNfactor: factor for PCS category N
pcsNjM: Mth judge score for PCS category N
pcsNt: PCS category N total (unfactored)
```

## Notes

- Olympics, GPF, and NHK Trophy PDFs were renamed by hand due to different naming conventions.

## To-do

- Do previous seasons
- Add Pairs and Dance
- Add a table for competitions with judge info and other stuff
- Dump stuff into database
- Check for number of judges in the code...(right now it assumes there are 9, but Shanghai Trophy for example didn't have 9)
- Names with umlauts and other stuff don't show up
