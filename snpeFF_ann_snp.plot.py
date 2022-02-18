#coding: utf-8
#2022-2-11

import os
import sys


ref_path = sys.argv[1]
fout_path = sys.argv[2]

###SNPeff ann SNP
ref_pos_dt = {}
fout_result_list = []
ref_impact_variants_dt = {}
with open(ref_path) as file:
    for line in file:
        val = line.strip()
        if val.count("#") != 0:
            pass
        else:
            j = line.strip().split()
            chr = j[0]
            pos = j[1]
            chr_cbind = chr + "-" + pos
            INFO = j[7]
            impact = "xxx"
            if INFO.count("HIGH") != 0:
                impact = "HIGH"
            else:
                if INFO.count("MODERATE") != 0:
                    impact = "MODERATE"
            if impact != "xxx":
                if impact == "HIGH":
                    if INFO.count("frameshift_variant") != 0:
                        TYPE = "3"
                    elif INFO.count("stop_gained") != 0:
                        TYPE= "4"
                elif impact == "MODERATE":
                    if INFO.count("missense_variant") != 0:
                        TYPE = "2"
                    else:
                        pass
            else:
                TYPE = "1"

            ref_impact_variants_dt[chr_cbind] = TYPE
            ref_pos_dt[int(pos)] = 0

fout_file = open(fout_path,"w")
result = ("Sample_hap","pos","TYPE","tmp")
fout_file.write("\t".join(result) + "\n")

start = 749000
end = 802000
for nu in range(start,end + 1):
    if nu in ref_pos_dt:
        pos = str(nu)
        chr = "KI270803.1"
        chr_pos = chr + "-" + pos
        if chr_pos in ref_impact_variants_dt:
            TYPE = ref_impact_variants_dt[chr_pos]
        result = ("refGRCh38_ALT",pos,TYPE,"1")
        fout_file.write("\t".join(result) + "\n")
fout_file.close()