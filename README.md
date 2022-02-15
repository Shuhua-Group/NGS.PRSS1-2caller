# NGS-PRSS-caller

NGS-PRSS-caller is a tool for solving misaligned short-reads of the pseudogenes PRSS3P2 and TRY7 at PRSS1-PRSS2 locus. NGS-PRSS-caller realigns short reads to GRCh38 ALT contig (chr7_KI270803v1_alt) from NGS aligned data (bam format), and detects variants including SNV, INDEL and CNV at PRSS1-PRSS2 locus with high accuracy and sensitivity. NGS-PRSS-caller can also annotate the biological consequences of a variant and perform variant phasing with population-level data.

## Installation

NGS-PRSS-caller does not need to be installed. You need to replace the software path in the parameter.txt file with your own software path.

The following software versions have been tested and passed:

software     version       weblink
> python     2.7           https://www.python.org/downloads/

> java       11.0.1        https://www.oracle.com/java/technologies/javase/jdk11-archive-downloads.html

> samtools   1.9           https://sourceforge.net/projects/samtools/files/samtools/

> bwa        0.7.17-r1188  https://github.com/lh3/bwa/releases

> freebayes  1.3.5         https://github.com/ekg/freebayes

> snpEff     4.3t          https://sourceforge.net/projects/snpeff/files/

> gatk       4.1.7.0       https://gatk.broadinstitute.org/hc/en-us/articles/360036194592-Getting-started-with-GATK4

## Usage
```
    NGS-PRSS-caller.sh -i [filelist] -m [num] -n [name]
```

## Options
```
Required arguments
    -i FILE  Tab-separated bam file list including *sample ID* / *bam file location* / *sample read depth* (U for unknown)

Optional arguments
    -m [num] Mapping quality (default=50)
    -n       Taskname
```

## Example
```
    ./NGS-PRSS-caller.sh -i example.list -n test
```

## Credit

Written by Wang Yimin & Xie bo, with contributions from Lou Haiyi.

## Contact

wangyimin@picb.ac.cn
