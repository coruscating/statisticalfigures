# Statistical Figures

Data science meets the ice.

## Data Format

`agg_elems.csv` has one line per element and `agg_progs.csv` has one line per program.

Common fields:

- comp: short code from filename, lowercased
- year: 2018
- discp: 0=Men, 1=Ladies
- seg: 0=SP, 1=FP
- skname: first names LAST NAME
- nat: 3 letter nation code from protocols


`agg_elems.csv` fields:

- elen: element # in program
- eles: element description with features and levels removed (ex: 3T+3T+3T, StSq)
- lvl: element level (for spins and step sequences), - if level not applicable
- bl: element backloaded (0=no, 1=yes)
- dg: element downgraded << (0=no, 1=yes)
- ur: element underrotated < (0=no, 1=yes)
- ue: element unclear edge ! (0=no, 1=yes)
- we: element wrong edge e (0=no, 1=yes)
- iv: element invalid * (0=no, 1=yes)
- ele: element full description (ex: 3T+3T<+3T*, StSq4)
- bv: element base value
- goe: element total GOE
- goejN: element GOE, judge N
- ets: element total score


`agg_progs.csv` fields:

- rank: rank in this segment
- order: starting order
- tss: total segment score
- tes: total element score
- tpcs: total PCS (factored)
- tded: total deductions
- tbv: total base value
- pcsNfactor: factor for PCS category N
- pcsNjM: Mth judge score for PCS category N
- pcsNt: PCS category N total (unfactored)

`agg_comp.csv` fields:

- 


## Retrieving Data

1. Score PDFs need to be downloaded from the ISU website. Here's one way to use Google to crawl for PDFs:

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

4. Run `parseprotocol.sh` to make plaintext files suitable for feeding into `protocoltodata.py`.

5. Run `protocoltodata.py` to generate `agg_elems.csv` and `agg_progs.csv`.

## Competition Abbreviations

```
+-------------------+-----------+
|    Competition    | Shortcode |
+-------------------+-----------+
| Olympics          | owg       |
| Olympics Team     | owgt      |
| Worlds            | wc        |
| 4CC               | fc        |
| Europeans         | ec        |
| GPF               | gpf       |
| GP Canada         | gpcan     |
| GP China          | gpchn     |
| GP France         | gpfra     |
| GP Japan          | gpjpn     |
| GP Russia         | gprus     |
| GP USA            | gpusa     |
| Nebelhorn         | csger     |
| Junior Worlds     | wjc       |
+-------------------+-----------+
```

## Notes

- Olympics, GPF, and NHK Trophy PDFs were renamed by hand due to different naming conventions.

## To-Do/Known Problems

- Do previous seasons
- Add Juniors, Pairs and Dance
- Add a table for competitions with judge info and other stuff
- Dump stuff into database
- Check for number of judges in the code...(right now it assumes there are 9, but Shanghai Trophy for example didn't have 9)
- Should V spins have that feature in the simple field? 
