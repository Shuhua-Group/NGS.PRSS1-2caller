# NGS-PRSS-caller

NGS-PRSS-caller is a tool for solving misaligned short-reads of the pseudogenes PRSS3P2 and TRY7 at PRSS1-PRSS2 locus. NGS-PRSS-caller realigns short reads to GRCh38 ALT contig (chr7_KI270803v1_alt) from NGS aligned data (bam format), and detects variants including SNV, INDEL and CNV at PRSS1-PRSS2 locus with high accuracy and sensitivity. NGS-PRSS-caller can also annotate the biological consequences of a variant and perform variant phasing with population-level data.

## Installation

NGS-PRSS-caller does not need to be installed. You need to replace the software path in the parameter.txt file with your own software path.

The following software versions have been tested and passed:

software     version       weblink
> python     2.7           https://www.python.org/downloads

> perl       5.22.1        https://www.perl.org/get.html

> java       11.0.1        https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html

> samtools   1.9           https://sourceforge.net/projects/samtools/files/samtools

> bwa        0.7.17-r1188  https://github.com/lh3/bwa/releases

> freebayes  1.3.5         https://github.com/ekg/freebayes

> beagle     5.2           http://faculty.washington.edu/browning/beagle

> snpEff     4.3t          https://sourceforge.net/projects/snpeff/files

> gatk       4.1.7.0       https://gatk.broadinstitute.org/hc/en-us/articles/360036194592-Getting-started-with-GATK4

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

## Expected outcomes

We generated the following results with the data in the NGS-PRSS-caller/exp/ directory. All output files can be found in the NGS-PRSS-caller/exp/example.out/ directory

1.Full variants mapping on GRCh38 ALT contig in vcf format (phased if you add [-p]).
* example_PRSS_snpEff_ann.vcf.gz

<img width="1457" alt="Screen Shot 2022-02-18 at 4 04 32 PM" src="https://user-images.githubusercontent.com/86826743/154642697-4197db0b-0f8a-40a0-bf1a-b43c58361277.png">

2.Full annotation results of your output variant list.
* example_PRSS_snpEff_ann.txt

<img width="1641" alt="Screen Shot 2022-02-18 at 4 09 36 PM" src="https://user-images.githubusercontent.com/86826743/154643403-d9be53a7-f708-4782-993f-f01b8d33384a.png">

3.variant figure.

4.Summary of missense variant carriers in your input samples.
* example_missense_sum.txt

<img width="409" alt="Screen Shot 2022-02-18 at 4 11 05 PM" src="https://user-images.githubusercontent.com/86826743/154643608-03112db3-7c7c-40c7-9f05-2ea4f772512e.png">

## Credit

Written by Wang Yimin & Xie bo, with contributions from Lou Haiyi.

## Contact

wangyimin@picb.ac.cn
