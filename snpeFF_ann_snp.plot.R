library(ggplot2)
library(ggthemes)

args <- commandArgs(trailingOnly = TRUE)
ref_exon_path = args[1]
ref_snp_file = args[2]
fout_path = args[3]

print(ref_exon_path)
print(ref_snp_file)
print(fout_path)
gene_data <- data.frame(gene = factor(c("PRSS1","PRSS3P1","PRSS3P2","TRY7","PRSS2"), levels = c("PRSS1","PRSS3P1","PRSS3P2","TRY7","PRSS2")), xpos = c(749900,760200,770700,781900,791800),ypos=c(1.5,1.5,1.5,1.5,1.5))
ref_exon_file = paste(ref_exon_path,sep='')
Exon_Data<-read.table(ref_exon_file,sep="\t",header=T,stringsAsFactors=FALSE)
ref_snp_file = paste(ref_snp_file,sep='')
SNP_Data<-read.table(ref_snp_file,sep="\t",header=T,stringsAsFactors=FALSE)
TYPE_list = c("1","2","3","4")
SNP_Data$TYPE <- factor(SNP_Data$TYPE,levels=TYPE_list)
Missense_SNP <- SNP_Data[SNP_Data$TYPE == "2",]
Frameshift_SNP <- SNP_Data[SNP_Data$TYPE == "3",]
stop_gained_SNP <- SNP_Data[SNP_Data$TYPE == "4",]
new_SNP_data <- rbind(Missense_SNP,Frameshift_SNP,stop_gained_SNP)
color_list <- c("#CC9933","#CC0033","#990066")
if (identical(as.vector(unique(new_SNP_data$TYPE)),c("2","3"))){
    color_list <- color_list <- c("#CC9933","#CC0033")
  } else if (identical(as.vector(unique(new_SNP_data$TYPE)),c("2","4"))){
    color_list <- color_list <- c("#CC9933","#990066")
  } else if (identical(as.vector(unique(new_SNP_data$TYPE)),c("3","4"))){
    color_list <- color_list <- c("#CC0033","#990066")
  } else if (identical(as.vector(unique(new_SNP_data$TYPE)),c("2"))){
    color_list <- color_list <- c("#CC9933")
  } else if (identical(as.vector(unique(new_SNP_data$TYPE)),c("3"))){
    color_list <- color_list <- c("#CC0033")
  } else if (identical(as.vector(unique(new_SNP_data$TYPE)),c("4"))){
    color_list <- color_list <- c("#990066")
  } else if (identical(as.vector(unique(new_SNP_data$TYPE)),c("2","3","4"))){
    color_list <- c("#CC9933","#CC0033","#990066")}
Missense_label <- paste("Missense (","nu=",as.character(nrow(Missense_SNP)),")",sep='')
Frameshift_label <- paste("Frameshift (","nu=",as.character(nrow(Frameshift_SNP)),")",sep='')
stop_gained_label <- paste("stop_gained (","nu=",as.character(nrow(stop_gained_SNP)),")",sep='')
new_SNP_data$TYPE <- factor(new_SNP_data$TYPE,levels=c("2","3","4"),labels=c(Missense_label,Frameshift_label,stop_gained_label))
p <- ggplot() + xlim(749000,802000) + scale_x_continuous(breaks=seq(750000,802000,10000)) + ylim(0,2) + 
geom_bar(data=new_SNP_data,aes(x=pos, y=tmp,fill=TYPE),width = 0.0000000001,stat = 'identity') + scale_fill_manual(values=color_list) +
geom_bar(data=SNP_Data[SNP_Data$TYPE == "1",],mapping = aes(x=pos, y=tmp),color="grey",fill="grey",width = 10,stat = 'identity',) +
geom_bar(data=SNP_Data[SNP_Data$TYPE == "2",],mapping = aes(x=pos, y=tmp),color="#CC9933",fill="#CC9933",width = 100,stat = 'identity',) + 
geom_bar(data=SNP_Data[SNP_Data$TYPE == "3",],mapping = aes(x=pos, y=tmp),color="#CC0033",fill="#CC0033",width = 200,stat = 'identity',) + 
geom_bar(data=SNP_Data[SNP_Data$TYPE == "4",],mapping = aes(x=pos, y=tmp),color="#990066",fill="#990066",width = 200,stat = 'identity',) + 
geom_rect(data=Exon_Data[Exon_Data$gene == "PRSS1",],aes(xmin = xstart,xmax = xend ,ymin = ystart , ymax = yend),fill = "#11345F") + 
geom_rect(data=Exon_Data[Exon_Data$gene == "PRSS3P1",],aes(xmin = xstart,xmax = xend , ymin = ystart , ymax = yend),fill = "#808080") + 
geom_rect(data=Exon_Data[Exon_Data$gene == "PRSS3P2",],aes(xmin = xstart,xmax = xend , ymin = ystart , ymax = yend),fill = "#808080") + 
geom_rect(data=Exon_Data[Exon_Data$gene == "TRY7",],aes(xmin = xstart,xmax = xend , ymin = ystart , ymax = yend),fill = "#808080") + 
geom_rect(data=Exon_Data[Exon_Data$gene == "PRSS2",],aes(xmin = xstart,xmax = xend , ymin = ystart , ymax = yend),fill = "#11345F") +
geom_segment(aes(x = 752065, xend = 755673, y = 1.5, yend = 1.5),color = "#11345F",size=1) + 
geom_segment(aes(x = 763010, xend = 766538, y = 1.5, yend = 1.5),color = "#808080",size=1) + 
geom_segment(aes(x = 773586, xend = 777110, y = 1.5, yend = 1.5),color = "#808080",size=1) + 
geom_segment(aes(x = 783678, xend = 787211, y = 1.5, yend = 1.5),color = "#808080",size=1) + 
geom_segment(aes(x = 793943, xend = 797532, y = 1.5, yend = 1.5),color = "#11345F",size=1) + 
geom_text(data=gene_data, aes(x=xpos,y=ypos,label=gene),size=8,fontface = "italic") + 
theme_few() + xlab("KI270803.1 position") + geom_hline(yintercept = 1,size=1) + 
theme(
  legend.title = element_blank(),
  axis.ticks=element_line(size=1.5), 
  axis.ticks.length=unit(0.3, "cm"), 
  axis.title.y = element_blank(),
  axis.text.y=element_blank(),
  axis.ticks.y=element_blank(),
  plot.title = element_text(hjust = 0.5),
  axis.text.x = element_text(size = 20),
  axis.title.x = element_text(size = 24),
  legend.text = element_text(size = 16),
  panel.border = element_rect(color="black",size=1.5))
p
fout_path = paste(fout_path,sep='')
  ggsave(p,file=fout_path, width=18, height=3)