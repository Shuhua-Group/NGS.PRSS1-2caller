#coding:utf-8


import time
import numpy as np
import os,sys,getopt
import multiprocessing
import subprocess
import getopt


def usage():
    """
Description
        -h,--help       print help message
        -s,--sample     sample id; infer from bamfile, if not given
        -d,--workdir    working directory; sub-dir for each tool/sample will be made automatically; current dir will be uesd, if not given
        -f,--bamfile    individual BAM file [required]
        -r,--reference  GRCh38 or GRCh37 [required]
        -e,--depth      individual BAM file depth [optional]
    /picb/humpopg/xiebo/conda/envs/py27/bin/python /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/tools/PRSS_pipeline/PGG.PRSSpipeline.genotype.py -s NA21127 -r GRCh38 -f /picb/humpopg-bigdata/xiebo/NGS/reference/PRSS_bam/bam_bai/NA21127.dedup.bam -e 39


"""
def out_help():
    print('usage:')
    print('-h,--help: print help message')
    print('-s,--sample: sample id; infer from bamfile, if not given')
    print('-d,--workdir: working directory; sub-dir for each tool/sample will be made automatically; current dir will be uesd, if not given')
    print('-f,--bamfile: individual BAM file [required]')
    print('-r,--reference: GRCh38 or GRCh37 [required]')
    print('-e,--depth: individual BAM file depth [optional]')
    print('Example: /picb/humpopg/xiebo/conda/envs/py27/bin/python /picb/humpopg-bigdata/xiebo/NGS/TJ1_SV/tools/PRSS_pipeline/PGG.PRSSpipeline.genotype.py -s NA21127 -r GRCh38 -f /picb/humpopg-bigdata/xiebo/NGS/reference/PRSS_bam/bam_bai/NA21127.dedup.bam -e 39')
    sys.exit(0)


def get_sample_depth():
    ref_bam_path = bam
    fout_header_path = fout_prefix + sample + ".bam_header.txt"
    os.system("samtools view -H %s > %s" %(ref_bam_path,fout_header_path))
    if reference == "GRCh37":
        chr_label = "no_chr"
    elif reference == "GRCh38":
        chr_label = "add_chr"

    line_nu = 0
    with open(fout_header_path) as file:
        for line in file:
            line_nu += 1
            if line_nu == 2:
                val = line.strip()
                if val.count("chr") != 0:
                    chr_label == "add_chr"
                else:
                    chr_label == "no_chr"
            elif line_nu > 2:
                break
    if (reference == "GRCh37") and (chr_label == "no_chr"):
        ref_exon_path = BIN + "/data/GRCh37.exon.no_chr.bed"
    elif (reference == "GRCh37") and (chr_label == "add_chr"):
        ref_exon_path = BIN + "/data/GRCh37.exon.add_chr.bed"
    elif (reference == "GRCh38") and (chr_label == "no_chr"):
        ref_exon_path = BIN + "/data/GRCh38.exon.no_chr.bed"
    elif (reference == "GRCh38") and (chr_label == "add_chr"):
        ref_exon_path = BIN + "/data/GRCh38.exon.add_chr.bed"

    fout_path = fout_prefix + sample + ".exon.samtools_depth.txt"
    os.system("samtools bedcov -Q 15 %s %s > %s" %(ref_exon_path,ref_bam_path,fout_path))

    total_len = 0
    total_reads_nu = 0
    with open(fout_path) as file:
        for line in file:
            j = line.strip().split()
            start = int(j[1])
            end = int(j[2])
            reads_nu = int(j[3])
            total_len += end - start
            total_reads_nu += reads_nu
    average_depth = float(total_reads_nu)/total_len
    print(sample + "-average_depth = " + str(average_depth))
    return(str(average_depth))


def intercept_PRSS_area():
    if reference == "GRCh37":
        PRSS_area = "7:142400000-142487000 9:33610000-33615000 9:33780000-33810000"
    elif reference == "GRCh38":
        PRSS_area = "7:142736720-142789572 9:33600466-33809231 chr7:142736720-142789572 chr9:33600466-33809231 chr7_KI270803v1_alt:739317-811562"
    ref_path = bam
    fout_path = fout_prefix + sample + ".PRSS.bam"
    os.system("samtools view -h %s %s |samtools view -bS - > %s" %(ref_path,PRSS_area,fout_path))
    os.system("samtools index %s" %(fout_path))


def get_fastq():
    ref_path = fout_prefix + sample + ".PRSS.bam"
    fout_path_1 = fout_prefix + sample + ".PRSS.R1.fq"
    fout_path_2 = fout_prefix + sample + ".PRSS.R2.fq"
    fout_path_3 = fout_prefix + sample + ".PRSS.singleton.fq"
    os.system("samtools view -h %s | samtools sort -n | samtools fastq -1 %s -2 %s -s %s - >/dev/null 2>&1" %(ref_path,fout_path_1,fout_path_2,fout_path_3))


def remapping_ALT():
    header_R = "@RG\\tID:" + sample + "\\tSM:" + sample + "\\tLB:" + sample + "\\tPU:" + sample + "\\tPL:ILLUMINA"
    ref_fasta = BIN + "/data/GRCh38.ALT_PRSS.fa"
    ref_fastq_1 = fout_prefix + sample + ".PRSS.R1.fq"
    ref_fastq_2 = fout_prefix + sample + ".PRSS.R2.fq"
    fout_pe_bam = fout_prefix + sample + ".PRSS.refGRCh38_ALT.remapping.pe.bam"
    fout_bam = fout_prefix + sample + ".PRSS.refGRCh38_ALT.remapping.bam"
    fout_dedup_bam = fout_prefix + sample + ".PRSS.refGRCh38_ALT.remapping.dedup.bam"
    metric_path = fout_prefix + "metric." + sample + ".txt"
    fout_logerr = fout_prefix + sample + ".logerr"
    os.system("time bwa mem -M -t 10 -R \"%s\" %s %s %s | samtools view -bS - > %s" %(header_R,ref_fasta,ref_fastq_1,ref_fastq_2,fout_pe_bam))
    os.system("time samtools sort -@ 5 -m 4G %s -o %s; samtools index %s " %(fout_pe_bam,fout_bam,fout_bam))
    os.system("time gatk --java-options \"-Xmx30G -XX:ParallelGCThreads=12\" MarkDuplicates -I %s -O %s --REMOVE_DUPLICATES true -M %s --ASSUME_SORT_ORDER coordinate --COMPRESSION_LEVEL 5 --VALIDATION_STRINGENCY SILENT --CREATE_INDEX true --TMP_DIR tmp/ " %(fout_bam,fout_dedup_bam,metric_path))
    os.system("rm %s" %(fout_pe_bam))
    os.system("rm %s" %(fout_bam))

def use_bedcov():
    ref_bed_path = BIN + "/data/GRCh38_ALT.PRSS_5copy.bed"
    ref_bam = fout_prefix + sample + ".PRSS.refGRCh38_ALT.remapping.dedup.bam"
    fout_path = fout_prefix + sample + ".GRCh38_ALT.PRSS1_5copy.remapping.remove_dup.bedcov.txt"
    os.system("samtools bedcov %s %s > %s" %(ref_bed_path,ref_bam,fout_path))

def fout_result(sample):
    print(sample)
    ref_gene_cbind_dt = {}
    ref_path = BIN + "/data/GRCh38_ALT.PRSS_5copy.txt"
    with open(ref_path) as file:
        for line in file:
            j = line.strip().split()
            gene_copy = j[0]
            gene_cbind = j[1]
            ref_gene_cbind_dt[gene_cbind] = gene_copy

    sample_depth = depth
    fout_result_list = []
    ref_path = fout_prefix + sample + ".GRCh38_ALT.PRSS1_5copy.remapping.remove_dup.bedcov.txt"
    with open(ref_path) as file:
        for line in file:
            j = line.strip().split()
            chr = j[0]
            start = j[1]
            end = j[2]
            gene_cbind = chr + ":" + start + "-" + end
            gene_copy = ref_gene_cbind_dt[gene_cbind]
            sum_depth = float(j[3])
            site_nu = int(j[2])-int(j[1]) + 1
            geno = 2*(sum_depth/site_nu)/float(sample_depth)
            result = [sample,gene_copy,gene_cbind,str(geno)]
            fout_result_list.append(result)

    fout_path = fout_prefix + sample + ".PRSS_5copy.primary_genotype.refGRCh38_ALT.remapping.bedcov.beta.txt"
    fout_file = open(fout_path,"w")
    result = ("sample","gene_copy","gene_cbind","geno")
    fout_file.write("\t".join(result) + "\n")       
    for result in fout_result_list:
        fout_file.write("\t".join(result) + "\n")
    fout_file.close()

    ref_sample_gene_copy_geno_dt = {}
    ref_path = fout_prefix + sample + ".PRSS_5copy.primary_genotype.refGRCh38_ALT.remapping.bedcov.beta.txt"
    line_nu = 0
    with open(ref_path) as file:
        for line in file:
            line_nu += 1
            if line_nu == 1:
                pass
            else:
                j = line.strip().split()
                sample = j[0]
                gene_copy = j[1]
                geno = j[3]
                sample_gene_copy_cbind = sample + "--" + gene_copy
                ref_sample_gene_copy_geno_dt[sample_gene_copy_cbind] = str(geno)

    ref_gene_copy_list = ["PRSS1","PRSS3P1","PRSS3P2","TRY7","PRSS2"]
    fout_path = fout_prefix + sample + ".PRSS_5copy.primary_genotype.refGRCh38_ALT.remapping.bedcov.matrix.beta.txt"
    fout_file = open(fout_path,"w")
    result = ("sample","remapping_bam","PRSS1","PRSS3P1","PRSS3P2","TRY7","PRSS2")
    fout_file.write("\t".join(result) + "\n")
    ref_dedup_bam = fout_prefix + sample + ".PRSS.refGRCh38_ALT.remapping.dedup.bam"
    result = [sample,ref_dedup_bam]
    for gene_copy in ref_gene_copy_list:
        sample_gene_copy_cbind = sample + "--" + gene_copy
        geno = str(int(float(ref_sample_gene_copy_geno_dt[sample_gene_copy_cbind]) + 0.5))
        result.append(geno)
    fout_file.write("\t".join(result) + "\n")
    fout_file.close()


def run():
    intercept_PRSS_area()
    get_fastq()
    remapping_ALT()
    use_bedcov()
    fout_result(sample)


if __name__ == '__main__':
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hs:d:f:r:e:", ["help","sample=","workdir=","bamfile=","reference=","depth="])
    except getopt.GetoptError as err:
        print(str(err))

    sample = "xxx"
    bam = "xxx"
    depth = "xxx"
    reference = "xxx"
    workdir = os.getcwd()
    BIN = str(os.path.split(os.path.realpath(__file__))[0]) + "/"

    for key, value in opts:
        if key in ['-h', '--help']:
            out_help()
        elif key in ['-d', '--workdir']:
            workdir = value
        elif key in ['-f', '--bamfile']:
            bam = value
        elif key in ['-s', '--sample']:
            sample = value
        elif key in ['-e','--depth']:
            depth = float(value)
        elif key in ['-r','--reference']:
            reference = value
        else:
            assert False,"Unhandled Option"
    if sample == "xxx":
        if sample.count("dedup") != 0:
            sample = bam.split("/")[-1].split(".dedup.bam")[0]
        elif sample.count("realigned") !=0:
            sample = bam.split("/")[-1].split(".realigned.bam")[0]
    fout_prefix = workdir + "/" + sample + "/"
    os.system("mkdir -p %s" %(fout_prefix))
    if depth == "xxx":
        depth = get_sample_depth()
    if (sample != "xxx") and (bam != "xxx") and (depth != "xxx") and (reference != "xxx"):
        run()
    else:
        out_help()
