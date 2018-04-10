
import sys
import string
import re
from os import path
from glob import glob  

# This script takes all text files in a directory and outputs two aggregated, agg_elems.csv and agg_scores.csv.


def find_ext(dr, ext): # return list of files of a particular extension
    return glob(path.join(dr,"*.{}".format(ext)))


for filename in find_ext("protocols/","txt"):
    filefields=filename.split("_")
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

    fo=open("agg_elems.csv", "w")
    fo2=open("agg_scores.csv", "w")
    fo.write("comp,year,discp,seg,skname,nat,rank,order,tss,tes,tpcs,tded,")
    fo2.write("comp,year,discp,seg,skname,nat,rank,order,tss,tes,tpcs,tded,")
    for i in range(7):
        fo.write("ele%dbl,ele%dur,ele%dinv,ele%dedg,ele%d,ele%dbv,ele%dgoe,"%(i+1,i+1,i+1,i+1,i+1,i+1,i+1))
        for j in range(9):
            fo.write("ele%dj%d,"%(i+1,j+1))
        fo.write("ele%dt,"%(i+1))

    fo2.write("bv,")
    for i in range(5):
        fo2.write("pcs%if," %(i+1))
        for j in range(9):
            fo2.write("pcs%dj%d,"%(i+1,j+1))
        fo2.write("pcs%dt"%(i+1))
    fo2.write("\n")

    with open(filename) as f:
        content = f.readlines()
    content = [x.strip() for x in content] 

    for i in range(len(content)):
        if content[i].startswith("Score"): # next line is skater
            #line=content[i+1].replace(" ",",")
            line=content[i+1]
            matches = re.findall(' [A-Z ]+ ', line) # first LAST NATION style
            if len(matches) > 0:
                matches=matches[0].split()
                nat=matches[-1]
                ln=matches[:-1] # don't know if anyone has multiple last names in ISU system...better safe than sorry
                fn=re.findall(' [A-Za-z ]+ ', line)[0]
                for lastnames in ln:
                    fn=fn.replace(lastnames,"") # really stupid way of extracting first name
                    line=line.replace(lastnames,"")
                fn=fn.replace(nat,"").strip()
            else:
                matches = re.findall(' [A-Z]+ ', line) # LAST first NATION style
                ln=matches[:-1]
                nat=matches[-1]
                fn=re.findall(' [A-Za-z ]+ ', line)[0]
                for lastnames in ln:
                    fn=fn.replace(lastnames,"") # really stupid way of extracting first name
                    line=line.replace(lastnames,"")
                fn=fn.replace(nat,"").strip()
            ln=" ".join(ln)
            line=line.replace(fn,"")
            line=line.replace(nat,"")
            line=','.join(line.split())
            fo.write(comp + "," + year + "," + str(discp) + "," + str(seg) + "," + fn + " " + ln + "," + nat + ",")
            fo.write(line)
            sys.exit()
        elif content[i].startswith("Elements"):
            i+=1
            for j in range(7): # elements
                line=content[i+j].replace(" ",",").split(",")[1:]
                features=["x","<<","<","!","e","*"] # important that << before < so it's not matched twice
                stuff=[0,0,0,0,0,0]
                for f in len(features):
                    if (features[f] in line):
                        line.remove(features[f])
                        stuff[f]=1
                fo.write(",".join(str(k) for k in stuff) + "," + ",".join(line) + ",")
            i+=7
            fo.write(content[i].split(' ')[0]+",") # total bv
            i+=2
            for j in range(5):
                line=re.sub('[^\d. ]','', content[i+j]).strip().replace(" ",",") # PCS
                print line
                fo.write(line.replace(" ",","))
            fo.write("\n")

