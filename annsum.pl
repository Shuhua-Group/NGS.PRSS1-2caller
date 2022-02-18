#!/usr/bin/perl
use strict;

my @vcffile;
my @samplist;

open(INFILE,"$ARGV[0]");
@vcffile=<INFILE>;
chomp @vcffile;
close INFILE;

open(OUT,">>$ARGV[1]_PRSS_snpEff_ann.sum.txt");
#analysis
my @header=split("\t",@vcffile[0]);
print OUT "#CHROM\tPOS\tREF\tALT\tTYPE\tcarrierID\n";
for (my $index = 9; $index < @header; $index++) {
	push(@samplist,@header[$index]);
}

for(my $i=1;$i<@vcffile;$i++){
	my @singlevcf=split("\t",@vcffile[$i]);
	print OUT @singlevcf[0]."\t".@singlevcf[1]."\t".@singlevcf[3]."\t".@singlevcf[4]."\t";
	if(@singlevcf[7] =~ /frameshift_variant/){
		print OUT "frameshift_variant\t";
	}elsif(@singlevcf[7] =~ /stop_gained/){
		print OUT "stop_gained\t";
	}elsif(@singlevcf[7] =~ /missense_variant/){
		print OUT "missense_variant\t";
	}
	for (my $index = 9; $index < @singlevcf; $index++) {
		my @cnsum=split(":",@singlevcf[$index]);
		if(@cnsum[0] ne "0|0" and @cnsum[0] ne "0/0"){
			print OUT @samplist[$index-9].";";
		}
	}
	print OUT "\n";
}
close (OUT);
