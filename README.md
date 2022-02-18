# NGS-PRSS-caller

NGS-PRSS-caller is a toolkit for calling genetic variants at PRSS1-PRSS2 locus, which can solve the problem of misaligned short-reads from the pseudogenes PRSS3P2 and TRY7. NGS-PRSS-caller realigns short reads to GRCh38 ALT contig (chr7_KI270803v1_alt) from NGS aligned data with GRCh38 as reference (file in bam format), and detects variants including SNV, INDEL and CNV at PRSS1-PRSS2 locus with high accuracy and sensitivity. NGS-PRSS-caller can also annotate the biological consequences of a variant and perform variant phasing with population-level data.

## Installation

NGS-PRSS-caller does not need to be installed. You need to replace the software path in the parameter.txt file with your own software path.

The following software versions have been tested and passed:

software     version       weblink
> python     2.7           https://www.python.org/downloads

> perl       5.22.1        https://www.perl.org/get.html

> java       11.0.1        https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html

> R          3.6.0         https://www.r-project.org
(with ggplot2,ggthemes)

> samtools   1.9           https://sourceforge.net/projects/samtools/files/samtools

> bwa        0.7.17-r1188  https://github.com/lh3/bwa/releases

> freebayes  1.3.5         https://github.com/ekg/freebayes

> beagle     5.2           http://faculty.washington.edu/browning/beagle

> snpEff     4.3t          https://sourceforge.net/projects/snpeff/files

> gatk       4.1.7.0       https://gatk.broadinstitute.org/hc/en-us/articles/360036194592-Getting-started-with-GATK4

The python package of NGS-PRSS-caller will be released soon.

## Usage
```
    NGS-PRSS-caller.sh -i [filelist] -m [num] -p -n [name]
```

## Options
```
Required arguments
    -i FILE  Tab-separated bam file list including *sample ID* / *bam file location* / *sample read depth* (U for unknown)

Optional arguments
    -m [num] Mapping quality (default=50)
    -p       Do phasing
    -n       Taskname
```

## Example
```
    ./NGS-PRSS-caller.sh -i example.list -p -n example
```

## Example output

We generated the following results with the data in the NGS-PRSS-caller/exp/ directory. The example data are the extracted bam files (NGS with GRCh38 as reference) from the 1000 Genomes Project and Human Genome Diversity Project samples (HG00581, HG03084, HG03490, HGDP00578).
All output files can be found in the NGS-PRSS-caller/exp/example.out/ directory. NGS-PRSS-caller can provide: 1) variants in variant call format (VCF) with phased information, 2) variants with predicted  biological consequences, 3) a plot of variant positions at PRSS1-PRSS2 locus, 4) a list of large-impact variants.

1. Variants detected based on GRCh38 ALT contig in vcf format (variants can be phased if you add [-p]).
* example_PRSS_snpEff_ann.vcf.gz

<img width="1457" alt="Screen Shot 2022-02-18 at 4 04 32 PM" src="https://user-images.githubusercontent.com/86826743/154642697-4197db0b-0f8a-40a0-bf1a-b43c58361277.png">

2.Variants in vcf format with biological consequences annotated.
* example_PRSS_snpEff_ann.txt (extracted)

<img width="1641" alt="Screen Shot 2022-02-18 at 4 09 36 PM" src="https://user-images.githubusercontent.com/86826743/154643403-d9be53a7-f708-4782-993f-f01b8d33384a.png">

3.Variant position plot with missense, stop-gained and frameshift variants highlighted。
* example_PRSS_snpEff_ann.plot.pdf

<img width="1528" alt="Screen Shot 2022-02-18 at 6 49 22 PM" src="https://user-images.githubusercontent.com/86826743/154668749-069b75b9-bc99-4de5-b296-32a3e73de2d9.png">

4.List of missense, stop-gained and frameshift variants. For a full list of large-impact variants, please refer to the variants annotated with "HIGH" and "MODERATE" at INFO column in the NAME_PRSS_snpEff_ann.txt file.
* example_PRSS_snpEff_ann.sum.txt

<img width="584" alt="Screen Shot 2022-02-18 at 6 53 14 PM" src="https://user-images.githubusercontent.com/86826743/154669379-36f53022-3d43-4cf0-9cc6-6b0e61012c6a.png">

## Credit

Written by Wang Yimin & Xie bo, with contributions from Lou Haiyi.

## Contact

wangyimin@picb.ac.cn
