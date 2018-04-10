
import sys
import string
import re
from os import path
from glob import glob  

# This script takes all text files in a directory and outputs two aggregated, agg_elems.csv and agg_scores.csv.


def find_ext(dr, ext): # return list of files of a particular extension
    return glob(path.join(dr,"*.{}".format(ext)))


fo=open("agg_elems.csv", "w")
fo2=open("agg_scores.csv", "w")


fo.write("comp,year,discp,seg,skname,nat,elen,eles,lvl,bl,dg,ur,ue,we,iv,ele,bv,goe,")
fo2.write("comp,year,discp,seg,skname,nat,rank,order,tss,tes,tpcs,tded,tbv,")

for j in range(9):
    fo.write("goej%d,"%(j+1))
fo.write("ets\n")

for i in range(5):
    fo2.write("pcs%if," %(i+1))
    for j in range(9):
        fo2.write("pcs%dj%d,"%(i+1,j+1))
    fo2.write("pcs%dt,"%(i+1))
fo2.write("\n")


for filename in find_ext("protocols/","txt"):
    if filename.startswith("protocols/owg") != True:
        continue
    filefields=filename.split("_")
    if len(filefields) < 2:
        continue
    if filefields[1] != "Men" and filefields[1] != "Ladies": # not singles, skip for now
        continue

    # get comp and year
    firstfield=filefields[0].split("/")[1]
    comp = firstfield.rstrip('0123456789')
    year = firstfield[len(comp):]

    if filefields[1]=="Men":
        discp=0
    else:
        discp=1
    if filefields[2]=="SP":
        seg=0
    else:
        seg=1


    with open(filename) as f:
        content = f.readlines()
    content = [x.strip() for x in content] 
    line_iter = iter(range(len(content)))
    for i in line_iter:
        if content[i].startswith("Score"): # next line is skater
            #line=content[i+1].replace(" ",",")
            line=content[i+1]
            rank=line.split()[0]

            matches = re.findall(' [A-Z-]+ [A-Z-]+ ', line) # first LAST NATION style

            if len(matches) > 0:
                matches=matches[0].split()
                nat=matches[-1].strip()
                ln=matches[:-1] # don't know if anyone has multiple last names in ISU system...better safe than sorry
                fn=re.findall(' [A-Za-z -]+ ', line)[0]
                for lastnames in ln:
                    fn=fn.replace(lastnames,"") # really stupid way of extracting first name
                fn=fn.replace(nat,"").strip()

            else:
                matches = re.findall(' [A-Z-]+ ', line) # LAST first NATION style
                ln=matches[:-1]
                nat=matches[-1].strip()
                fn=re.findall(' [A-Za-z -]+ ', line)[0]
                for lastnames in ln:
                    fn=fn.replace(lastnames,"") # really stupid way of extracting first name
                fn=fn.replace(nat,"").strip()

            ln=" ".join(ln).strip()

            line=','.join(line.split()[-5:])
            fo2.write(comp + "," + year + "," + str(discp) + "," + str(seg) + "," + fn + " " + ln + "," + nat + "," + rank + "," + line + ",")
            next(line_iter)
        elif content[i].startswith("1 "):
            #i+=1
            for j in range(7): # elements
               
                line=content[i+j].replace(" ",",").split(",")
                elen=line[0]
                features=["x","<<","<","!","e","*"] # important that << before < so it's not matched twice
                stuff=[0,0,0,0,0,0]
                for f in range(len(features)):
                    if (features[f] in line):
                        line.remove(features[f])
                        stuff[f]=1
                # make simple element
                eles=line[1]
                for f in features:
                    eles=eles.replace(f,"")
                if eles[-1].isdigit():
                    lvl=eles[-1]
                    eles=eles[:-1]
                else:
                    lvl="-"
                fo.write(comp + "," + year + "," + str(discp) + "," + str(seg) + "," + fn + " " + ln + "," + nat + ",")
                fo.write(elen + "," + eles + "," + lvl + "," + ",".join(str(k) for k in stuff) + "," + ",".join(line[1:]) + "\n")

        elif content[i].startswith("Program Components Factor"):
            fo2.write(content[i-1].split(' ')[0]+",")
            i+=1
            for j in range(5):
                line=re.sub('[^\d. ]','', content[i+j]).strip().replace(" ",",") # PCS
                fo2.write(line.replace(" ",",") + ",")
            fo2.write("\n")

            
            
