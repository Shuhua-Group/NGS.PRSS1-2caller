#!/usr/bin/perl
use strict;

my @gtfile;
my @cnfile;
my @samplist;
my %copy1;
my %copy2;
my %copy3;
my %copy4;
my %copy5;
my $del1=0;
my $del2=0;
my $del3=0;
my $del4=0;
my $del5=0;

open(INFILE,"$ARGV[0]");
@gtfile=<INFILE>;
chomp @gtfile;
close INFILE;

open(INFILE,"$ARGV[1]");
@cnfile=<INFILE>;
chomp @cnfile;
close INFILE;

for (my $i = 0; $i < @cnfile; $i++) {
	my @singlecn=split("\t",@cnfile[$i]);
	if(@singlecn[2] eq "2"){
		$copy1{"@singlecn[0]"}=2;
	}elsif(@singlecn[2] eq "1"){
		$copy1{"@singlecn[0]"}=1;
		$del1++;
	}elsif(@singlecn[2] eq "0"){
		$copy1{"@singlecn[0]"}=0;
		$del1++;
	}else{
		print "Error: cn =".@cnfile[$i]."?\n";
		exit (1);
	}
	if(@singlecn[3] eq "2"){
		$copy2{"@singlecn[0]"}=2;
	}elsif(@singlecn[3] eq "1"){
		$copy2{"@singlecn[0]"}=1;
		$del2++;
	}elsif(@singlecn[3] eq "0"){
		$copy2{"@singlecn[0]"}=0;
		$del2++;
	}else{
		print "Error: cn =".@cnfile[$i]."?\n";
		exit (1);
	}
	if(@singlecn[4] eq "2"){
		$copy3{"@singlecn[0]"}=2;
	}elsif(@singlecn[4] eq "1"){
		$copy3{"@singlecn[0]"}=1;
		$del3++;
	}elsif(@singlecn[4] eq "0"){
		$copy3{"@singlecn[0]"}=0;
		$del3++;
	}else{
		print "Error: cn =".@cnfile[$i]."?\n";
		exit (1);
	}
	if(@singlecn[5] eq "2"){
		$copy4{"@singlecn[0]"}=2;
	}elsif(@singlecn[5] eq "1"){
		$copy4{"@singlecn[0]"}=1;
		$del4++;
	}elsif(@singlecn[5] eq "0"){
		$copy4{"@singlecn[0]"}=0;
		$del4++;
	}else{
		print "Error: cn =".@cnfile[$i]."?\n";
		exit (1);
	}
	if(@singlecn[6] eq "2"){
		$copy5{"@singlecn[0]"}=2;
	}elsif(@singlecn[6] eq "1"){
		$copy5{"@singlecn[0]"}=1;
		$del5++;
	}elsif(@singlecn[6] eq "0"){
		$copy5{"@singlecn[0]"}=0;
		$del5++;
	}else{
		print "Error: cn =".@cnfile[$i]."?\n";
		exit (1);
	}
}
open(OUT,">>$ARGV[2]_PRSS.reshape.vcf");
#analysis
for(my $i=0;$i<@gtfile;$i++){
	if (@gtfile[$i] =~ /##/){
		print OUT @gtfile[$i]."\n";
	}elsif(@gtfile[$i] =~ /#/){
		my @singlegt=split("\t",@gtfile[$i]);
		for (my $index = 9; $index < @singlegt; $index++) {
			push(@samplist,@singlegt[$index]);
		}
		print OUT @gtfile[$i]."\n";
	}else{
		my @singlegt=split("\t",@gtfile[$i]);
		my $pos=@singlegt[1];
		if($pos <= 10697){
			if($del1 == 0){
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4]."\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my @cnsum=split(":",@singlegt[$j]);
					print OUT "\t".@cnsum[0];
				}
			}else{
				my $altcount=split(",",@singlegt[4]);
				my $delindex=$altcount+1;
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4].",<DEL>\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my $currgt=$copy1{"@samplist[$j-9]"};
					my @cnsum=split(":",@singlegt[$j]);
					if($currgt == 2){
						if (@cnsum[0] eq "." or @cnsum[0] eq "./0") {
							print OUT "\t0/0";
						}else{
							print OUT "\t".@cnsum[0];
						}
					}elsif($currgt == 1){
						if (@cnsum[0] eq ".") {
							print OUT "\t0/".$delindex;
						}else{
							print OUT "\t".@cnsum[0]."/".$delindex;
						}
					}elsif($currgt == 0){
						print OUT "\t".$delindex."/".$delindex;
					}
				}
			}
			print OUT "\n";
		}elsif($pos <= 21277){
			if($del2 == 0){
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4]."\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my @cnsum=split(":",@singlegt[$j]);
					print OUT "\t".@cnsum[0];
				}
			}else{
				my $altcount=split(",",@singlegt[4]);
				my $delindex=$altcount+1;
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4].",<DEL>\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my $currgt=$copy2{"@samplist[$j-9]"};
					my @cnsum=split(":",@singlegt[$j]);
					if($currgt == 2){
						if (@cnsum[0] eq "." or @cnsum[0] eq "./0") {
							print OUT "\t0/0";
						}else{
							print OUT "\t".@cnsum[0];
						}
					}elsif($currgt == 1){
						if (@cnsum[0] eq ".") {
							print OUT "\t0/".$delindex;
						}else{
							print OUT "\t".@cnsum[0]."/".$delindex;
						}
					}elsif($currgt == 0){
						print OUT "\t".$delindex."/".$delindex;
					}
				}
			}
			print OUT "\n";
		}elsif($pos <= 31854){
			if($del3 == 0){
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4]."\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my @cnsum=split(":",@singlegt[$j]);
					print OUT "\t".@cnsum[0];
				}
			}else{
				my $altcount=split(",",@singlegt[4]);
				my $delindex=$altcount+1;
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4].",<DEL>\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my $currgt=$copy3{"@samplist[$j-9]"};
					my @cnsum=split(":",@singlegt[$j]);
					if($currgt == 2){
						if (@cnsum[0] eq "." or @cnsum[0] eq "./0") {
							print OUT "\t0/0";
						}else{
							print OUT "\t".@cnsum[0];
						}
					}elsif($currgt == 1){
						if (@cnsum[0] eq ".") {
							print OUT "\t0/".$delindex;
						}else{
							print OUT "\t".@cnsum[0]."/".$delindex;
						}
					}elsif($currgt == 0){
						print OUT "\t".$delindex."/".$delindex;
					}
				}
			}
			print OUT "\n";
		}elsif($pos <= 41656){
			if($del4 == 0){
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4]."\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my @cnsum=split(":",@singlegt[$j]);
					print OUT "\t".@cnsum[0];
				}
			}else{
				my $altcount=split(",",@singlegt[4]);
				my $delindex=$altcount+1;
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4].",<DEL>\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my $currgt=$copy4{"@samplist[$j-9]"};
					my @cnsum=split(":",@singlegt[$j]);
					if($currgt == 2){
						if (@cnsum[0] eq "." or @cnsum[0] eq "./0") {
							print OUT "\t0/0";
						}else{
							print OUT "\t".@cnsum[0];
						}
					}elsif($currgt == 1){
						if (@cnsum[0] eq ".") {
							print OUT "\t0/".$delindex;
						}else{
							print OUT "\t".@cnsum[0]."/".$delindex;
						}
					}elsif($currgt == 0){
						print OUT "\t".$delindex."/".$delindex;
					}
				}
			}
			print OUT "\n";
		}elsif($pos <= 52149){
			if($del5 == 0){
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4]."\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my @cnsum=split(":",@singlegt[$j]);
					print OUT "\t".@cnsum[0];
				}
			}else{
				my $altcount=split(",",@singlegt[4]);
				my $delindex=$altcount+1;
				print OUT @singlegt[0]."\t".@singlegt[1]."\t".@singlegt[2]."\t".@singlegt[3]."\t".@singlegt[4].",<DEL>\t".@singlegt[5]."\t".@singlegt[6]."\t".@singlegt[7]."\t".@singlegt[8];
				for (my $j = 9; $j < @singlegt; $j++) {
					my $currgt=$copy5{"@samplist[$j-9]"};
					my @cnsum=split(":",@singlegt[$j]);
					if($currgt == 2){
						if (@cnsum[0] eq "." or @cnsum[0] eq "./0") {
							print OUT "\t0/0";
						}else{
							print OUT "\t".@cnsum[0];
						}
					}elsif($currgt == 1){
						if (@cnsum[0] eq ".") {
							print OUT "\t0/".$delindex;
						}else{
							print OUT "\t".@cnsum[0]."/".$delindex;
						}
					}elsif($currgt == 0){
						print OUT "\t".$delindex."/".$delindex;
					}
				}
			}
			print OUT "\n";
		}else{
			print "Error: POS =".$pos."\n";
			exit (1);
		}
	}
}
close (OUT);
