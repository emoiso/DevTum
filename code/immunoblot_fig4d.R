#! bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#this script generates immuno scores and its relative boxplot in 
library(ggplot2)
load('dep_files/color_annotations.rsave')
load('dep_files/normalize.rsave')
campioni=read.delim('dep_files/tcga_samples.csv.gz',sep=',',stringsAsFactors = F)
rownames(campioni)[1]='sample'
a3_tcga_m=read.delim('dep_files/tcga_raw_dcs.csv',sep=',',stringsAsFactors = F)
colnames(a3_tcga_m)=gsub('^_','',fixed=F,paste(unlist(lapply(strsplit(colnames(a3_tcga_m), '__'),'[',2)),unlist(lapply(strsplit(colnames(a3_tcga_m), '__'),'[',1)),sep = '-'))

#immuno score calculation
immuno=a3_tcga_m[campioni$rownames.a.[campioni$tissue_type=='TP'],z3$v1[z3$Main_trajectory_refined_by_cluster=='Haematopoiesis trajectory']]
immuno_score=apply(immuno,1,sum)
immuno_df=merge(as.data.frame(immuno_score), campioni,by.x=0,by.y=1)
#sorting tumor names by median immuno score
immuno_med=unlist(lapply(unique(campioni$sample), function(x){median(immuno_score[campioni$rownames.a.[campioni$tissue_type=='TP'&campioni$sample==x]])}))
names(immuno_med)=unique(campioni$sample)
#final immuno score df
immuno_df$sample=factor(immuno_df$sample,levels =names(sort(immuno_med,decreasing = T)))
immuno_df$immuno_score_01=normalize(immuno_df$immuno_score)

colori_umap=c('goldenrod4',#ACC
                              'mistyrose2',#Blca
                              'maroon1',#brca
                              'orange',#cesc
                              'blue4',#chol
                              'cyan',#coad
                              'indianred',#dlbc
                              'chartreuse4',#esca
                              'dodgerblue',#gbm
                              'darkseagreen',#hnsc
                              'brown1',#kich
                              'brown2',#kirc
                              'brown3', #kirp
                              'tan4',#laml
                              'dodgerblue4',#lgg
                              'lightsteelblue',#lihc
                              'plum',#luad
                              'plum4',#lusc
                              'purple4',#meso
                              'orange3',#ov
                              'lightsteelblue4',#paad
                              'darkgoldenrod2',#pcpg
                              'darkred',#prad
                              'cyan4',#read
                              'aquamarine4',#sarc
                              'darkkhaki',#skcm
                              'chartreuse',#stad
                              'red',#tgct
                              'gold',#thca
                              'tan',#thym
                              'peachpuff',#ucec
                              'darkorange',#ucs
                              'darkgreen'#uvm
)
names(colori_umap)=sort(unique(campioni$sample))

pdf('figs/paper/Fig4D.pdf',height  = 8,width = 15)
ggplot(data = immuno_df ,aes(x=sample, y=immuno_score_01, fill=sample)) +
  geom_violin(width=2,position = position_dodge(6)) +
  geom_boxplot(width=0.1, color="black", alpha=0.9,position = position_dodge(2)) +
  scale_fill_manual(values = scales::alpha(colori_umap,alpha = .5)) +
  theme_minimal() +
  theme(
    legend.position="bottom",
    plot.title = element_text(size=11),
    text = element_text(size=20, color='black'),
    axis.text.x = element_text(color = "black", angle = 45, vjust = .5), #size = 20, angle = 0, hjust = .5, vjust = 0, face = "plain"),
    axis.text.y = element_text(color = "black"), #size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain"),
    axis.line = element_line(colour = 'black', size = 1),
    axis.ticks.length.y = unit(.25, "cm"),axis.ticks.length.x = unit(.25, "cm")
  ) +labs(fill='Tumor type' , y='Normlaized Immuno Score',x='Tumor type')
dev.off()

