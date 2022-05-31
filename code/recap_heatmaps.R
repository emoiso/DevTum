#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#This script does: 


#1 preform hierarchical clustering on rows and columns
#2 create columns and rows annotations
#3 create columns and rows annotation colors
#4 create the final heatmap of e7 obtained from 02_data_recap.R as seen in figure fig2C/2B

path_to_e7='' #file path
output_file='' #file path
path_to_cell_annotations='' file path
path_to_sample_annotations='' file path


library(pheatmap)
library(RColorBrewer)
load(path_to_cell_annotations)
load(path_to_sample_annotations)


#
#1
#
e7_hc_r=hclust(dist(e7), method = 'ward.D')
e7_hc_c=hclust(dist(t(e7)), method = 'ward.D')
#
#2
#
annotation_r=data.frame(row.names = rownames(e7),
                         Main_trajectory=gsub('trajectory','',cell_annotations$Main_trajectory_refined_by_cluster[match(rownames(e7), cell_annotations$Sub_trajectory_name)])
                         ,stringsAsFactors = T)
annotation_c=data.frame(row.names = colnames(e7),
                         Tissue_type=gsub('TB', 'TP',unlist(lapply(strsplit(colnames(e7), '_'),'[',2))),
                         Tumor=unlist(lapply(strsplit(colnames(e7), '_'),'[',1))
                         ,stringsAsFactors = T)
#
#3
#
mycolors2=list(Main_trajectory = c('brown','burlywood','tomato','lightsalmon','thistle','darkolivegreen','dodgerblue','deepskyblue','blue','navy'),
               Tissue_type=c('lawngreen','thistle','cadetblue'),
               Tumor=col2=c('goldenrod4',#ACC
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
)
names(mycolors2$Main_trajectory) <- levels(annotation_r$Main_trajectory)
names(mycolors2$Tissue_type) <- levels(annotation_c$Tissue_type)
names(mycolors2$Tumor) <- levels(annotation_c$Tumor)
#
#4
#
pdf(output_file, height = 21, width = 24)
x=pheatmap::pheatmap(e7, cluster_cols = e7_hc_c, cluster_rows = e7_hc_r, cutree_cols = 6,cutree_rows = 6,
                   col=c(rev(brewer.pal(9, 'Blues'))[-9],'grey80',
                         brewer.pal(9, 'Reds')[-1]),
                   scale = 'column',
                   annotation_row = annotation_r,#fontsize_row = 15,fontsize_col = 15,
                   fontsize = 18,
                   annotation_col = annotation_c,
                   labels_row = gsub('primitive_er','Primitive_er',gsub('_trajectory', '',rownames(e7))),
                   labels_col = unlist(lapply(strsplit(colnames(e7), '_'),'[',1)),annotation_colors = annotation_colors)
dev.off()
