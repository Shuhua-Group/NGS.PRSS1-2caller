#coding:utf-8

import os
import sys
import gzip


ref_snpeff_prefix = sys.argv[1]
ref_gff_prefix = sys.argv[2]
ref_vcf_path = sys.argv[3]
fout_vcf_path = sys.argv[4]
fout_snpeff_path = sys.argv[5]

snpefff_jar_path = ref_snpeff_prefix + "/snpEff.jar"
config_path = ref_snpeff_prefix + "/data/GRCh38_ALT_PRSS/snpEff.config"
database_path = ref_snpeff_prefix + "/data/"

if os.path.exists(fout_vcf_path + ".gz"):
	os.system("rm %s.gz" %(fout_vcf_path))

fout_file = open(fout_vcf_path,"w")
if ref_vcf_path.count("gz") != 0:
	with gzip.open(ref_vcf_path) as file:
		for line in file:
			val = line.strip()
			if val.count("#") != 0:
				fout_file.write(line)
			else:
				j = line.strip().split()
				j[0] = "KI270803.1"
				j[1] = str(int(j[1]) + 749408)
				fout_file.write("\t".join(j) + "\n")
else:
	with open(ref_vcf_path) as file:
		for line in file:
			val = line.strip()
			if val.count("#") != 0:
				fout_file.write(line)
			else:
				j = line.strip().split()
				j[0] = "KI270803.1"
				j[1] = str(int(j[1]) + 749408)
				fout_file.write("\t".join(j) + "\n")
fout_file.close()

os.system("bgzip %s" %(fout_vcf_path))
os.system("tabix -p vcf %s.gz" %(fout_vcf_path))


#run snpEff
os.system("java -Xmx4g -jar %s -v GRCh38_ALT_PRSS %s.gz -c %s -datadir %s  1> %s" %(snpefff_jar_path,fout_vcf_path,config_path,database_path,fout_snpeff_path))  

