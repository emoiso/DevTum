#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#This script does: 
#1 take as input the results of the calssification of the purity cohort and store the data in a list to facilitate handling
#2 generate associated metadata and store the data in a list to facilitate handling
#3 calculate classification accuracy
#4 generates barplot of accuracy over purtity per tumor type and across all tumor types
#5 generate label files for ROC AUC statistics calculation



#dependencies
library(ggplot2)
library(ggpubr)
library(reshape2)

#1
path_to_purity_tcga_class_res='' #path to file
path_to_purity_sc_class_res='' #path to file
output_labels='' #path to file
output_graph='' #path to output graphs, set one per desired graph


res=lapply(c(path_to_purity_sc_class_res,path_to_purity_tcga_class_res),function(x){
  a1=read.csv(x, header = T, rownames)
})
names(res)=c('sc','tcga')

#2
metadati=lapply(res, function(x){data.frame(id=rownames(x),stringsAsFactors = F)})
metadati$sc$tumor=unlist(lapply(strsplit(metadati$sc$id,'__'),'[',1))
metadati$sc$mix=unlist(lapply(lapply(strsplit(metadati$sc$id,'__'),rev),'[',1))
sc_dizio=cbind(sort(unique(metadati$sc$tumor)), c('LAML',"BRCA","COADREAD","GBMLGG",'HNSC','KIDNEY','LIHC','LUNG','SKCM','OV','PAAD','PRAD','SARC'))
tcga_dizio=unique(campioni[campioni$dataset=='TCGA',c(1,3)])
for(i in 1:nrow(sc_dizio)){
  metadati$sc$tumor=gsub(sc_dizio[i,1],sc_dizio[i,2],metadati$sc$tumor)
}
metadati$tcga$tumor=unlist(lapply(strsplit(metadati$tcga$id,'.',fixed = T),'[',1))
for(i in 1:nrow(tcga_dizio)){
  metadati$tcga$tumor=gsub(tcga_dizio[i,1],tcga_dizio[i,2],metadati$tcga$tumor)
}
metadati$tcga$tumor=gsub('COADCOADREAD','COADREAD',metadati$tcga$tumor)
metadati$tcga$mix=unlist(lapply(strsplit(metadati$tcga$id,'__'),'[',2))
metadati=lapply(metadati, function(x){
  x$mix=gsub('0$','0.0',fixed = F,x$mix )
  x$mix[x$mix=='1']='1.0'
  x
})

#3
#identify label of best prediction
metadati$sc$pred=unlist(lapply(1:nrow(res$sc),function(x){
  tail(names(sort(res$sc[x,])),1)
}))
metadati$tcga$pred=unlist(lapply(1:nrow(res$tcga),function(x){
  tail(names(sort(res$tcga[x,])),1)
}))
#create a vector were the indicates where the best response is top1, 2, 3, 4+ 
metadati$sc$top=rep_len(4,nrow(res$s))
for (x in 1:nrow(res$sc)){
  q2=res$sc[x,]
  q4=metadati$sc$tumor[x]
  for(i in 0:3){
    q3=tail(names(q2)[order(q2)], n=i)
    if(any(q3%in%q4)){break}
    metadati$sc$top[x]=i+1
   }
}

metadati$tcga$top=rep_len(4,nrow(res$tcga))
for (x in 1:nrow(res$tcga)){
  q2=res$tcga[x,]
  q4=metadati$tcga$tumor[x]
  for(i in 0:3){
    q3=tail(names(q2)[order(q2)], n=i)
    if(any(q3%in%q4)){break}
    metadati$tcga$top[x]=i+1
  }
}

#generation of an accuracy matrix, %
accuracy_sc=matrix(NA, nrow = 4,ncol = 11)
for(i in 1:4){
  for(i2 in 1:11){
    j=unique(metadati$sc$mix)[i2]
    accuracy_sc[i,i2]=cumsum(table(metadati$sc$top[metadati$sc$mix==j]))[i]/sum(table(metadati$sc$top[metadati$sc$mix==j]))}
}
accuracy_tcga=matrix(NA, nrow = 4,ncol = 11)
for(i in 1:4){
  for(i2 in 1:11){
    j=unique(metadati$tcga$mix)[i2]
    accuracy_tcga[i,i2]=cumsum(table(metadati$tcga$top[metadati$tcga$mix==j]))[i]/sum(table(metadati$tcga$top[metadati$tcga$mix==j]))}
}
#storing the results in a list
accuracy_overall=list(sc=accuracy_sc,
                      tcga=accuracy_tcga)
accuracy_overall=lapply(accuracy_overall, function(x){
  rownames(x)=as.character(1:4)
  colnames(x)=unique(metadati$tcga$mix)
  x=reshape2::melt(x)
  x[,1]=as.factor(x[,1])
  x[,2]=as.factor(x[,2])
  x
})

#generation of an accuracy matrix, counts
accuracy_sc_count=matrix(NA, nrow = 4,ncol = 11)
for(i in 1:4){
  for(i2 in 1:11){
    j=unique(metadati$sc$mix)[i2]
    accuracy_sc_count[i,i2]=table(metadati$sc$top[metadati$sc$mix==j])[i]}
}

accuracy_tcga_count=matrix(NA, nrow = 4,ncol = 11)
for(i in 1:4){
  for(i2 in 1:11){
    j=unique(metadati$tcga$mix)[i2]
    accuracy_tcga_count[i,i2]=table(metadati$tcga$top[metadati$tcga$mix==j])[i]}
}
#storing the results in a list
accuracy_overall_count=list(sc=accuracy_sc_count,
                      tcga=accuracy_tcga_count)
accuracy_overall_count=lapply(accuracy_overall_count, function(x){
  rownames(x)=as.character(1:4)
  colnames(x)=unique(metadati$tcga$mix)
  x=reshape2::melt(x)
  x[,1]=as.factor(x[,1])
  x[,2]=as.factor(x[,2])
  x
})

#organize accuracy results per tumor
accuracy_pertum_count=lapply(metadati,function(x){
  do.call('rbind',lapply(unique(x$tumor),function(x2){
    t1=table(x$top[x$tumor==x2],x$mix[x$tumor==x2])
    t2=reshape2::melt(t1)
    t2[,1]=as.factor(t2[,1])
    t2[,2]=as.factor(t2[,2])
    t2$tumor=x2
    t2$n=sum(t1[,1])
    t2
  }))
})

#4
#generates barplot of aggregated accuracy

pdf('figs/paper/figS12A_bar.pdf',width = 6.4,height=4.8)
ggplot(accuracy_overall_count$sc, aes(fill=Var1, y=value, x=Var2)) +
  geom_bar( position = position_fill(reverse = T),stat = 'identity')+theme_classic()+
  scale_fill_manual(values = (c(blues9[c(7,8,9)],'grey')))+
  labs(y='Accuracy',x='Purity',fill='Concordant result in top')+
  theme(legend.position = 'top',axis.text.x = element_text(colour = 'black'),
        text = element_text(size=20, color='black'),
        axis.text.y = element_text(color = "black"), #size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain"),
        axis.line = element_line(colour = 'black', size = 1),
        axis.ticks.length.y = unit(.25, "cm"),axis.ticks.length.x = unit(.25, "cm"))
dev.off()

pdf('figs/paper/figS12B_bar.pdf',width  = 6.4,height=4.8)
ggplot(accuracy_overall_count$tcga, aes(fill=Var1, y=value, x=Var2)) +
  geom_bar( position = position_fill(reverse = T),stat = 'identity')+theme_classic()+
  scale_fill_manual(values = (c(blues9[c(7,8,9)],'grey')))+
  labs(y='Accuracy',x='Purity',fill='Concordant result in top')+
  theme(legend.position = 'top',axis.text.x = element_text(colour = 'black'),
              text = element_text(size=20, color='black'),
              axis.text.y = element_text(color = "black"), #size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain"),
              axis.line = element_line(colour = 'black', size = 1),
              axis.ticks.length.y = unit(.25, "cm"),axis.ticks.length.x = unit(.25, "cm"))
dev.off()

#generates barplot of accuracy per tumor

pdf('figs/paper/figS12C.pdf',width = 10,height = 17)
bp=ggplot(accuracy_pertum_count$sc, aes(fill=Var1, y=value, x=Var2)) + 
  geom_bar(position=position_fill(reverse = T), stat="identity")+theme_classic()+
  scale_fill_manual(values = (c(blues9[c(7,8,9)],'grey')))+
  labs(y='Accuracy',x='Purity',fill='Concordant result in top')+
  theme(legend.position = 'bottom',axis.text.x = element_text( colour = 'black'),
        text = element_text(size=20, color='black'),
        axis.text.y = element_text(color = "black"), #size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain"),
        axis.line = element_line(colour = 'black', size = 1),
        axis.ticks.length.y = unit(.25, "cm"),axis.ticks.length.x = unit(.25, "cm"))
facet(bp,ncol = 2, facet.by = 'tumor',panel.labs = list(tumor=unlist(lapply(sort(unique(accuracy_pertum$sc$tumor)), function(x){paste0(c(x,unique(accuracy_pertum$sc$n[accuracy_pertum$sc$tumor==x])),collapse = ', n= ')}))))
dev.off()

pdf('figs/paper/figS12D.pdf',width = 10,height = 17)
bp=ggplot(accuracy_pertum_count$tcga, aes(fill=Var1, y=value, x=Var2)) + 
  geom_bar(position=position_fill(reverse = T), stat="identity")+theme_classic()+
  scale_fill_manual(values = (c(blues9[c(7,8,9)],'grey')))+
  labs(y='Accuracy',x='Purity',fill='Concordant result in top')+
  theme(legend.position = 'bottom',axis.text.x = element_text( colour = 'black'),
        text = element_text(size=20, color='black'),
        axis.text.y = element_text(color = "black"), #size = 20, angle = 90, hjust = .5, vjust = .5, face = "plain"),
        axis.line = element_line(colour = 'black', size = 1),
        axis.ticks.length.y = unit(.25, "cm"),axis.ticks.length.x = unit(.25, "cm"))
facet(bp,ncol = 2, facet.by = 'tumor',panel.labs = list(tumor=unlist(lapply(sort(unique(accuracy_pertum$tcga$tumor)), function(x){paste0(c(x,unique(accuracy_pertum$tcga$n[accuracy_pertum$tcga$tumor==x])),collapse = ', n= ')}))))
dev.off()

#5
#generate label matrices for ROC AUC calculation
etichette=lapply(metadati,function(x){
  x1=lapply(unique(x$mix),function(x2){
    a1=as.data.frame.matrix(table(x[x$mix==x2,c(1,2)]))
    a2=matrix(0, nrow = nrow(a1),ncol = 27-ncol(a1))
    colnames(a2)=sort(unique(campioni$tum2))[-7][!sort(unique(campioni$tum2))[-7]%in%colnames(a1)]
    a3=cbind(a1,a2)
    a3=a3[,sort(unique(campioni$tum2))[-7]]
  })
  names(x1)=unique(x$mix)
  x1
})

lapply(names(etichette$tcga),function(x){
  write.table(etichette$tcga[[x]],quote = F,sep = ',', row.names = F, col.names = F,file=paste0(output_labels,'_tcga.csv'))
})


lapply(names(risultati$sc),function(x){
  write.table(risultati$sc[[x]],quote = F,row.names = F, col.names = F,sep = ',',file=paste0(output_labels,'_sc.csv'))
})

