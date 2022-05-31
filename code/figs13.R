#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#this files generate the plots seen in  figs13 from the classification results of the relative test sets


library(ggplot2)
load('dep_files/sankeyplot.rsave')

path_to_class_res=''#path to class res for s13ab or s13cd data
#1
res=read.delim(path_to_class_res,sep=',',stringsAsFactors = F)
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
accuracy_bytum_count_df$Var1=factor(as.character(accuracy_bytum_count_df$Var1),levels =unique(labs$L1)[c(8,11,7,17,10,18,19,12,23,3,27,6,15,9,13,22,21,1,24,20,4,25,16,2,26,14,5)] )
accuracy_bytum_count_df$Var2=as.factor(accuracy_bytum_count_df$Var2)


#3
pdf(paste0('figs/paper/figs13_',x,'pdf'),width = 6.4,height=4.8)
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


#5
#generate class labels, answers and confusion matrix for ROC AUC calculation
#stored in la list
class_res_metrics=list(
  table(labs[,c(1,4)]),
  table(labs[,c(1,2)]),
  table(labs[,c(2,4)])
)
names(class_res_metrics)=c('labs', 'answ','conf')
