#coding:utf-8

import os
import sys


ref_snpeff_prefix = sys.argv[1]
ref_gff_prefix = sys.argv[2]


###1. Get a GFF file (into path/to/snpEff/data/GRCh38_ALT_PRSS/genes.gff.gz)
ref_gff_path = ref_gff_prefix + "/genes.gff.gz"
os.system("mkdir -p %s/data/GRCh38_ALT_PRSS" %(ref_snpeff_prefix))
os.system("cp %s %s/data/GRCh38_ALT_PRSS" %(ref_gff_path,ref_snpeff_prefix))


###2. Get a fasta file (into path/to/snpEff/data/GRCh38_ALT_PRSS/sequences.fa)
ref_fa_path = ref_gff_prefix + "/sequences.fa"
fout_fa_path = ref_snpeff_prefix + "/data/GRCh38_ALT_PRSS/sequences.fa"
os.system("cp %s %s/data/GRCh38_ALT_PRSS" %(ref_fa_path,ref_snpeff_prefix))


###3. Edit the config file to create the new genome:
def snpEff_config(fout_path):
	fout_file = open(fout_path,"w")
	fout_file.write("# GRCh38_ALT_PRSS, GENCODE_v39 GRCh38_ALT_PRSS" + "\n")
	fout_line = "GRCh38_ALT_PRSS.genome : " + fout_fa_path + "\n"
	fout_file.write(fout_line)
	fout_file.close()

fout_path = ref_snpeff_prefix + "/data/GRCh38_ALT_PRSS/snpEff.config"
if os.path.exists(fout_path):
	line_nu = 0
	with open(fout_path) as file:
		for line in file:
			line_nu += 1
			if line_nu == 1:
				val = line.strip()
				if val == "# GRCh38_ALT_PRSS, GENCODE_v39 GRCh38_ALT_PRSS":
					pass
				else:
					os.system("rm %s" %(fout_path))
					snpEff_config(fout_path)
else:
	snpEff_config(fout_path)


###4. Create database (note the "-gff3" flag):
snpefff_jar_path = ref_snpeff_prefix + "/snpEff.jar"
config_path = ref_snpeff_prefix + "/data/GRCh38_ALT_PRSS/snpEff.config"
database_path = ref_snpeff_prefix + "/data/"
os.system("java -jar %s build -gff3 -v GRCh38_ALT_PRSS -c %s -datadir %s" %(snpefff_jar_path,config_path,database_path))


