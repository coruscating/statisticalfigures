
import sys
import string
import re
from os import path
from glob import glob  

# This script takes all text files in a directory and outputs two aggregated CSVs, agg_elems.csv and agg_progs.csv.
# See README for field descriptions

dirlist={"season1718/", "season1617/","season1516/"}


# discp, field, # of elements for each
discpdict={"Men": [0,0,[7,13]], "Ladies":[1,0,[7,12]],"JuniorMen":[0,1,[7,12]],"JuniorLadies":[1,1,[7,11]]}

# disciplines to include
dispinc={"Men","Ladies","JuniorMen","JuniorLadies"}

def find_ext(dr, ext): # return list of files of a particular extension
    return glob(path.join(dr,"*.{}".format(ext)))


fo=open("agg_elems.csv", "w")
fo2=open("agg_progs.csv", "w")



fo.write("comp,year,discp,field,seg,skname,nat,elen,eles,lvl,bl,dg,ur,ue,we,iv,ele,bv,goe,")
fo2.write("comp,year,discp,field,seg,skname,nat,rank,order,tss,tes,tpcs,tded,tbv,")

for j in range(9):
    fo.write("goej%d,"%(j+1))
fo.write("ets\n")

for i in range(5):
    fo2.write("pcs%if," %(i+1))
    for j in range(9):
        fo2.write("pcs%dj%d,"%(i+1,j+1))
    fo2.write("pcs%dt,"%(i+1))
fo2.write("\n")


for directory in dirlist:
    for filename in find_ext("protocols/"+directory,"txt"):
        print filename
        filefields=filename.split("_")
        if len(filefields) < 2:
            continue
        segtype=filefields[1]
        if segtype in discpdict and segtype in dispinc:
            discp=discpdict[segtype][0]
            field=discpdict[segtype][1]
        else:
            continue

        # get comp and year
        firstfield=filefields[0].split("/")[2]
        comp = firstfield.rstrip('0123456789')
        year = firstfield[len(comp):]


        if filefields[2]=="SP":
            seg=0
        else:
            seg=1

        with open(filename) as f:
            content = f.readlines()
        content = [x.strip() for x in content] 
        line_iter = iter(range(len(content)))
        for i in line_iter:
            if "Score Score" in content[i]:
                k=0
                while (not content[i+k].split()[0].isdigit()): # look for skater
                    k+=1
                #line=content[i+1].replace(" ",",")
                line=content[i+k].split()
                rank=line[0]
                score=line[-5:]
                nat=line[-6]

                if line[-7].isupper(): # first LAST NATION style
                    ln=line[-7]
                    fn=line[1:-7]

                else: # LAST first NATION style
                    ln=line[1]
                    fn=line[2:-6]

                fn=" ".join(fn)
                score=",".join(score)

                next(line_iter)
            elif content[i].startswith("1 "):
                #i+=1
                for j in range(discpdict[segtype][2][seg]):
                    line=content[i+j].replace(" ",",").split(",")
                    elen=line[0]
                    features=["x","<<","<","!","e","*"] # important that << before < so it's not matched twice
                    stuff=[0,0,0,0,0,0]
                    for f in range(len(features)):
                        if (features[f] in line): 
                            line.remove(features[f])
                            stuff[f]=1
                        elif (features[f].upper() in line):
                            line.remove(features[f].upper())
                            stuff[f]=1
                    # make simple element
                    eles=line[1]
                    for f in features:
                        eles=eles.replace(f,"")
                    if eles[-1].isdigit():
                        lvl=eles[-1]
                        eles=eles[:-1]
                    elif eles[-1]=="V" and eles[-2].isdigit(): # a V spin
                        lvl=eles[-2]
                        eles=eles[:-2]
                    elif eles[-1]=="B": # basic level
                        lvl="B"
                        eles=eles[:-1]
                    else:
                        lvl="-"
                    for pad in range(13-len(line[1:])): # fewer than 9 judges
                        line.insert(-1,'-')
                    eles=eles.replace("+COMBO","")
                    eles=eles.replace("+REP","")
                    fo.write(comp + "," + year + "," + str(discp) + "," + str(field) + "," + str(seg) + "," + fn + " " + ln + "," + nat + ",")
                    fo.write(elen + "," + eles + "," + lvl + "," + ",".join(str(k) for k in stuff) + "," + ",".join(line[1:]) + "\n")

            elif content[i].startswith("Program Components Factor"):
                fo2.write(comp + "," + year + "," + str(discp) + "," + str(field) + "," + str(seg) + "," + fn + " " + ln + "," + nat + "," + rank + "," + score + ",")
                fo2.write(content[i-1].split(' ')[0]+",")
                i+=1
                for j in range(5):
                    line=re.sub('[^\d. ]','', content[i+j]).strip().split(" ") # PCS
                    for pad in range(11-len(line)): # fewer than 9 judges
                        line.insert(-1,'-')
                    fo2.write(",".join(line)+",")
                fo2.write("\n")

                
                
