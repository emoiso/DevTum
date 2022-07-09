#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#this files generate the radar plot matrix show in figs6b and relative legend
library(viridis)
f_colore_vi=function(x){
  require(viridis)
  y=ifelse(x==9.5, viridis(5)[1],
           ifelse(x==10.5, viridis(5)[2],
                  ifelse(x==11.5,viridis(5)[3],
                         ifelse(x==12.5,viridis(5)[4],
                                viridis(5)[5]))))
  y
}



load('dep_files/radarchart4.rsave')
load('dep_files/color_annotations.rsave')

col_annot=read.csv('dep_file/normal_pseudobulk_meta.csv.gz')
data0_sc2=read.csv('dep_file/normal_pseudobulk_dc.csv.gz')


#
#figS6B
#
png('figs/paper/figS6B.png',width = 25, height = 10, units = 'in',res = 300)
par(mar=c(0,0,0,0))
par(mfrow=c(2,5))
n=1
for(i in 1:nrow(a)){
  print(i)
  cz=col_annot[rownames(data0_sc2),]
  cz=cz[cz$cell_type==a[i,1],]
  cz=cz[grep(a[i,2],fixed = F,invert = T,cz$sample),]
  data1=as.matrix(data0_sc2[cz$sample,])
  a[i,3]=nrow(data1)
  data=as.data.frame(rbind(rep_len(max(data1),ncol(data1)),
                           rep_len(min(data1),ncol(data1)),
                           data1,
                           rep_len(min(data1),ncol(data1))))  
  par(mar=c(0,0,0,0))
  radarchart4(data[,z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.5), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
              vlabelscol =z3$col2[order(z3$v5)],
              vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
              pcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),NA) , pfcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),'white'))
  
  
  text(x=0,y=0,cex=5,i, col='black',adj = 0.5)#a[i,1]
  n=n+1
  
}
dev.off()

#legend
pdf('figs/paper/figS6B_legend.pdf', height = 8, width = 4)
par(mar=c(0,0,0,0))
plot(rep_len(1,10),1:10,xlim = c(1,1.3),type='n',col='black',pch=19,cex=2,axes = F,ylab = '',xlab = '')
text(rep_len(1.03,10),1:10,labels = rev(paste(1:10,unique(col_Annot$cell_type),sep  = '. ')), col='black', pos=4)
dev.off()
