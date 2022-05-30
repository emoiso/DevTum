#! bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 09/23/2019

#this script generates tcga DCs radarplots in fig4a-c and figs8a-b and figs9

library(scales)
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

#data loading
load('dep_files/color_annotations.rsave')
load('dep_files/radarchart4.rsave')
load('dep_files/normalize.rsave')
campioni=read.delim('dep_files/tcga_samples.csv.gz',sep=',',stringsAsFactors = F)
rownames(campioni)[1]='sample'
a3_tcga_m=read.delim('dep_files/tcga_raw_dcs.csv',sep=',',stringsAsFactors = F)

#mean centering and sd scaling
a3_tcga_m_sc=as.data.frame(scale(a3_tcga_m))
#min max normalization
a3_tcga_m_sc=as.data.frame(apply(a3_tcga_m_sc, 2,normalize))

#
#Fig3D
#
{data1=data1[campioni$sample[campioni$tum=='LIHC'&campioni$tissue_type=='TP'],]
data=as.data.frame(rbind(rep_len(max(data1),nrow(data1)),
                         rep_len(min(data1),nrow(data1)),
                         data1,
                         rep_len(min(data1),nrow(data1))))  
colnames(data)=gsub('^_','',fixed=F,paste(unlist(lapply(strsplit(colnames(data), '__'),'[',2)),unlist(lapply(strsplit(colnames(data), '__'),'[',1)),sep = '-'))


png('figs/paper/Fig3D.png',height = 10,width = 10,res=300,units = 'in')
par(mar=c(0,0,0,0))
radarchart4(data[c(1:2,c(100, nrow(data))),z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.5), cglty=1,cglwd = 2, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,calcex = 1.5, 
            vlabelscol =z3$col2[order(z3$v5)],
            vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='*',
            pcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),NA) , pfcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),'white'))
dev.off()
}
#
#Fig4A,B,C
#
#LIHC
{data1=a3_tcga_m_sc
data1=data1[campioni$sample[campioni$sample=='LIHC'&campioni$tissue_type=='TP'],]
data=as.data.frame(rbind(rep_len(max(data1),nrow(data1)),
                         rep_len(min(data1),nrow(data1)),
                         data1,
                         rep_len(min(data1),nrow(data1))))
colnames(data)= gsub('_9','9',paste(unlist(lapply(strsplit(colnames(data),'__'),'[',2)),unlist(lapply(strsplit(colnames(data),'__'),'[',1)),sep = '-'))

png('figs/paper/Fig4A',height = 10,width = 10,res=300,units = 'in')
par(mar=c(0,0,0,0))
radarchart4(data[c(1:2,c(100, nrow(data))),z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.5), cglty=1,cglwd = 2, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,calcex = 1.5, 
            vlabelscol =z3$col2[order(z3$v5)],
            vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='*',
            pcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),NA) , pfcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),'white'))
dev.off()
#LGG
data1=a3_tcga_m_sc
data1=data1[campioni$sample[campioni$sample=='LGG'&campioni$tissue_type=='TP'],]
data=as.data.frame(rbind(rep_len(max(data1),nrow(data1)),
                         rep_len(min(data1),nrow(data1)),
                         data1,
                         rep_len(min(data1),nrow(data1))))
colnames(data)= gsub('_9','9',paste(unlist(lapply(strsplit(colnames(data),'__'),'[',2)),unlist(lapply(strsplit(colnames(data),'__'),'[',1)),sep = '-'))

png('figs/paper/Fig4B',height = 10,width = 10,res=300,units = 'in')
par(mar=c(0,0,0,0))
radarchart4(data[c(1:2,c(100, nrow(data))),z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.5), cglty=1,cglwd = 2, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,calcex = 1.5, 
            vlabelscol =z3$col2[order(z3$v5)],
            vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='*',
            pcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),NA) , pfcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),'white'))
dev.off()
#PAAD
data1=a3_tcga_m_sc
data1=data1[campioni$sample[campioni$sample=='PAAD'&campioni$tissue_type=='TP'],]
data=as.data.frame(rbind(rep_len(max(data1),nrow(data1)),
                         rep_len(min(data1),nrow(data1)),
                         data1,
                         rep_len(min(data1),nrow(data1))))
colnames(data)= gsub('_9','9',paste(unlist(lapply(strsplit(colnames(data),'__'),'[',2)),unlist(lapply(strsplit(colnames(data),'__'),'[',1)),sep = '-'))

png('figs/paper/Fig4B',height = 10,width = 10,res=300,units = 'in')
par(mar=c(0,0,0,0))
radarchart4(data[c(1:2,c(100, nrow(data))),z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.5), cglty=1,cglwd = 2, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,calcex = 1.5, 
            vlabelscol =z3$col2[order(z3$v5)],
            vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='*',
            pcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),NA) , pfcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),'white'))
dev.off()
}

#
#FigS8A
#
#data preparation 
{data1=a3_tcga_m_sc
data1=data1[campioni$sample[campioni$sample=='LIHC'&campioni$tissue_type=='TP'],]
data=as.data.frame(rbind(rep_len(max(data1),nrow(data1)),
                         rep_len(min(data1),nrow(data1)),
                         data1,
                         rep_len(min(data1),nrow(data1))))
colnames(data)= gsub('_9','9',paste(unlist(lapply(strsplit(colnames(data),'__'),'[',2)),unlist(lapply(strsplit(colnames(data),'__'),'[',1)),sep = '-'))
#radarplot
set.seed(123)
png('figs/paper/figS8A',height = 10,width = 20,res=300,units = 'in')
par(mar=c(0,0,0,0))
par(mfrow=c(2,4))
n=1
for(i in sample(x = 3:nrow(data),size = 8)){
  radarchart4(data[c(1:2,i, nrow(data)),z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
              vlabelscol =z3$col2[order(z3$v5)],
              vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
              pcol=c(scales::alpha(viridis::plasma(1),alpha = 1),NA) , pfcol=c(scales::alpha(viridis::plasma(1),alpha = 1),'white'))
  text(x=0,y=0,cex=7,n, col='black',adj = 0.5)
  n=n+1
}
dev.off()
#radarplot legend
set.seed(123)
pdf('figs/paper/figS8A_legend.pdf', height = 3, width = 4)
par(mar=c(0,0,0,0))
plot(rep_len(1,8),1:8,xlim = c(1,1.3),type='n',pch=19,cex=2,axes = F,ylab = '',xlab = '')
text(rep_len(1.03,8),1:8,labels = rev(paste(1:8, rownames(data)[sample(x = 3:nrow(data),size = 8)],sep  = '. ')), col='black', pos=4)
dev.off()
}

#
#FigS8B
#
#data preparation 
{data1=a3_tcga_m_sc
data1=data1[campioni$sample[campioni$sample=='LGG'&campioni$tissue_type=='TP'],]
data=as.data.frame(rbind(rep_len(max(data1),nrow(data1)),
                         rep_len(min(data1),nrow(data1)),
                         data1,
                         rep_len(min(data1),nrow(data1))))
colnames(data)= gsub('_9','9',paste(unlist(lapply(strsplit(colnames(data),'__'),'[',2)),unlist(lapply(strsplit(colnames(data),'__'),'[',1)),sep = '-'))
#radarplot
set.seed(123)
png('figs/paper/figS8B.png',height = 10,width = 20,res=300,units = 'in')
par(mar=c(0,0,0,0))
par(mfrow=c(2,4))
n=1
for(i in sample(x = 3:nrow(data),size = 8)){
  radarchart4(data[c(1:2,i, nrow(data)),z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
              vlabelscol =z3$col2[order(z3$v5)],
              vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
              pcol=c(scales::alpha(viridis::plasma(1),alpha = 1),NA) , pfcol=c(scales::alpha(viridis::plasma(1),alpha = 1),'white'))
  text(x=0,y=0,cex=7,n, col='black',adj = 0.5)
  n=n+1
}
dev.off()
#radarplot legend
set.seed(123)
pdf('figs/paper/figS8B_legend.pdf', height = 3, width = 4)
par(mar=c(0,0,0,0))
plot(rep_len(1,8),1:8,xlim = c(1,1.3),type='n',pch=19,cex=2,axes = F,ylab = '',xlab = '')
text(rep_len(1.03,8),1:8,labels = rev(paste(1:8, rownames(data)[sample(x = 3:nrow(data),size = 8)],sep  = '. ')), col='black', pos=4)
dev.off()
}

#
#FigS9 radar matrix 
#
{png('figs/paper/igS9.png',width = 50, height = 70, units = 'in',res = 300)
par(mar=c(0,0,0,0))
par(mfrow=c(7,5))
n=1
data1=as.data.frame(scale(a3_tcga_m))
data1=as.data.frame(apply(data1, 2,normalize))#2,a=0,b=1 
for(i in sort(unique(campioni$sample))){
  print(i)
  data=data1[campioni$rownames.a.[campioni$sample==i&campioni$tissue_type=='TP'],]
  data=as.data.frame(rbind(rep_len(max(data),nrow(data)),
                           rep_len(min(data),nrow(data)),
                           data,
                           rep_len(min(data),nrow(data))))  
  colnames(data)=gsub('^_','',fixed=F,paste(unlist(lapply(strsplit(colnames(data), '__'),'[',2)),unlist(lapply(strsplit(colnames(data), '__'),'[',1)),sep = '-'))
  
  par(mar=c(0,0,0,0))
  radarchart4(data[,z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
              vlabelscol =z3$col2[order(z3$v5)],
              vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
              pcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),NA) , pfcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),'white'))
  
  text(x=0,y=0,cex=10,n, col='black',adj = 0.5)
  n=n+1
}
dev.off()

#FigS9 radar matrix legend 
pdf('figs/paper/figS9_legend.pdf', height = 8, width = 4)
par(mar=c(0,0,0,0))
plot(rep_len(1,33),1:33,xlim = c(1,1.3),type='n',col='white',pch=19,cex=2,axes = F,ylab = '',xlab = '')
text(rep_len(1.03,33),1:33,labels = rev(paste(1:33,sort(unique(campioni$sample)) ,sep  = '. ')), col='black', pos=4)
dev.off()
}