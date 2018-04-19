# Statistical Figures

Data science meets the ice.

## Data Format

`agg_elems.csv` has one line per element and `agg_progs.csv` has one line per program.

Common fields:

- comp: short code from filename, lowercased
- year: 20XX
- discp: 0=Men, 1=Ladies
- field: 0=Senior, 1=Junior
- seg: 0=SP, 1=FP
- skname: first names LAST NAME
- nat: 3 letter nation code from protocols


`agg_elems.csv` fields:

- elen: element # in program
- eles: simple element description with features and levels removed (ex: 3T+3T+3T, StSq)
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
- num#: number of jumps attempted of # of rotations (num3=number of triples)
- pcsNfactor: factor for PCS category N
- pcsNjM: Mth judge score for PCS category N
- pcsNt: PCS category N total (unfactored)

`agg_seg.csv` fields (to-do):

- refname: referee name
- jNname: name of judge N
- jNnat: country of judge N
- cont: technical controller
- spec: technical specialist
- aspec: assistant technical specialist
- dat: data operator
- rep: replay operator


## Retrieving Data

1. Get a list of PDFs with relevant search term (only works for newer seasons):

```
./dlpdflist.sh season1718
```

2. Batch download protocols:

```
./dlprotocols.sh season1718
```

4. Make plaintext files from PDFs:

```
./parseprotocols.sh season1718
```

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
| Winter Universiade| wu        |
+-------------------+-----------+
```

## Notes

- Olympics, GPF, and NHK Trophy PDFs were renamed by hand due to different naming conventions.

## To-Do/Known Problems

- Get remaining competitions (challengers, nationals?, misc)
- Do previous seasons
- Add Pairs and Dance
- Add a table for competitions with judge info and other stuff
- Dump stuff into database
- Older protocols have more than 9 judges...
- Check for number of elements on the protocols (instead of assuming a number based on discipline)
- Make competition list, download older protocols

## Changelog

- Added seasons 2015-16 and 2016-17
- Competitions fewer than 9 judges will now have '-' for the fields with no judges
- Added Juniors
- Fixed B step sequence simple description and levels
- Fixed V spin simple description and levels
- Fixed +COMBO, +REP simple description