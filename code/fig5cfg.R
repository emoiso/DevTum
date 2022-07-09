#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#this script generates the plot for fig5C-F and fis11
#1it takes as input the likelihood matrix, produced by the DMLP
#2 generates statistics on the top 4 classification
#3 generates accuracy barplot as in fig5c
#4 generates sankey plot fig5fe
#5 generates statistics for roc auc

library(ggplot2)
library(alluvial)
load('dep_files/sankeyplot.rsave')

#1
res=read.delim('dep_files/data_fig5_class_res.csv.gz',sep=',',stringsAsFactors = F)
labs=read.delim('dep_files/data_fig5_test_lables.csv.gz',sep=',',stringsAsFactors = F)
res=res[match(rownames(res),labs$value),]

#2
#top1-4 results
labs$top=rep_len(4,nrow(res))
labs$top1=rep_len(NA, nrow(res))
for (x in 1:nrow(res)){
  q2=res[x,]
  q4=labs$L1[x]
  for(i in 0:3){
    q3=tail(names(q2)[order(q2)], n=i)
    if(i==1){
      labs$top1[x]=q3
    }
    if(any(q3%in%q4)){break}
    labs$top[x]=i+1
  }
}

overall_accuracy=cumsum(table(labs$top))/sum(table(labs$top))

#generation of an accuracy dataframe
accuracy_bytum_count_df=reshape2::melt(table(labs$L1,labs$top))
#organize samples by accuracy frequency
accuracy_bytum_count_df$Var1=factor(as.character(accuracy_bytum_count_df$Var1),levels = names(sort((table(labs$L1,labs$top)/apply(table(labs$L1,labs$top),1,sum))[,1],decreasing = T))[c(1:24,27,26,25)])
accuracy_bytum_count_df$Var2=as.factor(accuracy_bytum_count_df$Var2)


#3
pdf('figs/paper/fig5C.pdf',width = 6.4,height=4.8)
ggplot(accuracy_bytum_count_df, aes(fill=Var2, y=value, x=Var1)) +
  geom_bar( position = position_fill(reverse = T),stat = 'identity')+theme_classic()+
  scale_fill_manual(values = (c(blues9[c(7,8,9)],'grey')))+
  labs(y='Accuracy',x='Purity',fill='Concordant result in top')+
  theme(legend.position = 'top',axis.text.x = element_text(colour = 'black', angle = 45,hjust = 1),
        text = element_text(size=20, color='black'),
        axis.text.y = element_text(color = "black"), #size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain"),
        axis.line = element_line(colour = 'black', size = 1),
        axis.ticks.length.y = unit(.25, "cm"),axis.ticks.length.x = unit(.25, "cm"))
dev.off()

#4

col2=c('goldenrod4',#ACC
                       'mistyrose2',#Blca
                       'maroon1',#brca
                       'orange',#cesc
                       'blue4',#chol
                       'cyan',#coadread
                       'indianred',#dlbc
                       'dodgerblue',#gbm
                       'darkseagreen',#hnsc
                       'brown',#kid
                       'tan4',#laml
                       'lightsteelblue',#lihc
                       'plum',#lung
                       'purple4',#meso
                       'darkorange',#ov
                       'lightsteelblue4',#paad
                       'darkgoldenrod2',#pcpg
                       'darkred',#prad
                       'aquamarine4',#sarc
                       'darkkhaki',#skcm
                       'chartreuse',#stes
                       'red',#tgct
                       'gold',#thca
                       'tan',#thym
                       'peachpuff',#ucec
                       'darkorange',#ucs
                       'darkgreen'#uvm
)
#4

dato=as.data.frame(table(labs[,c(2,4)]),stringsAsFactors = F)
colnames(dato)[1]='q4'
colnames(dato)[2]='q3'
dato$right=NA
for(i in 1:nrow(dato)){
  dato$right[i]=dato$q4[i]==dato$q3[i]
}
  
sankey_plot_pdf(
  nomefile = 'figs/paper/fig5f.pdf',
  dato =dato,
  modello='',
  colori = col2 ,height = 15,width=15)


sankey_plot_pdf(
  nomefile = 'figs/paper/fig5g.pdf',
  dato =dato[dato$right==F,],
  modello='',
  colori = col2 ,height = 15,width=15)

#5
#generate label matrices for ROC AUC calculation
etichette=table(labs[,1:2])
    

