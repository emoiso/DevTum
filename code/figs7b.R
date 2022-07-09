#!/bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 02/29/2022

#this files generate the plot for the umap shown in figS7B


load('dep_files/data_figs7b.rsave')

pdf('figs/paper/figS7B.pdf',height = 7,width = 10)
par(mfrow=c(1,1))
par(mar=c(.1,.1,.1,.1))
plot(nonmalignant_umap, xaxt='n',yaxt='n',cex=1.5, pch=20, col=nonmalignant_annot$col[match(rownames(nonmalignant_umap),nonmalignant_annot$sample)])
legend('bottomleft',col = unique(nonmalignant_annot[,c(1,4)])[,2], legend = unique(nonmalignant_annot[,c(1,4)])[,1], bty = 'n',pch=20,cex = 1.5)
dev.off()
