#! bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#this script generates the plots of tcga umap based on DCs


#data loading
load('dep_files/umap_fig4ef_figs10.rsave')
campioni=read.delim('dep_files/tcga_samples.csv.gz',sep=',',stringsAsFactors = F)
rownames(campioni)[1]='sample'
{colori_umap=c('goldenrod4',#ACC
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
}



pdf('figs/paper/fig4e.pdf', width = 9, height = 9)
par(mar=c(0,0,0,0))
plot(sc1_umap_.5_.75$layout,pch=20,cex=.5,xaxt='n',yaxt='n', col=colori_umap[match(campioni$sample, names(colori_umap))])
dev.off()

pdf('figs/paper/fig4f.pdf', width = 9, height = 9)
par(mar=c(0,0,0,0))
plot(sc1_umap_.5_.75$layout,pch=20,cex=.9,xaxt='n',yaxt='n', col=ifelse(grepl('-01.$|-03.$',fixed = F,rownames(sc1_umap_.5_.75$layout)),'cadetblue',
                                                                        ifelse(grepl('-06.$',fixed = F,rownames(sc1_umap_.5_.75$layout)),'thistle',
                                                                               ifelse(grepl('-11.$',fixed = F,rownames(sc1_umap_.5_.75$layout)),'lawngreen','grey'))))
dev.off()


png('figs/paper/figs10.png',width = 9, height = 12, units = 'in',res = 300)
par(mar=c(0,0,0,0))
par(mfrow=c(7,5))
for(i in sort(unique(campioni$sample))){
  plot(sc1_umap_.5_.75$layout,pch=20,cex=.3,xaxt='n',yaxt='n', col=scales::alpha('grey',alpha = .3))
  points(sc1_umap_.5_.75$layout[rownames(sc1_umap_.5_.75$layout)%in%campioni$rownames.a.[campioni$sample==i],],pch=20,cex=.8,xaxt='n',yaxt='n', col=colori_umap[names(colori_umap)==i])
  text(x=-25,y=17,cex=2,i, col=colori_umap[names(colori_umap)==i],adj = 0,pos = 4)
}
dev.off()
