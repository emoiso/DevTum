#! bin/Rscript
#Author: Enrico Moiso
#email: em.metaminer@gmail.com
#Date: 09/23/2019

#this files generate the radar plots and the heatmap in figs3BC, figS6a and figS7A



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
load('dep_files/data_fig3bc_fs6a_fs7a.rsave')
load('dep_files/normalize.rsave')

png('figs/paper/fig3b_1fibro.png',width = 10, height = 10, units = 'in',res = 300)
{par(mfrow=c(1,1))
par(mar=c(0,0,0,0))
data=data02[grep('fibro',ignore.case = T,rownames(data02)),]
set.seed(123)
camp=sample(1:nrow(data),16)[11]

data=as.data.frame(rbind(rep_len(max(data02),ncol(data)),
                         rep_len(min(data02),ncol(data)),
                         data[camp,],
                         rep_len(min(data02),ncol(data)))
)  

radarchart4(data[,z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
            vlabelscol =z3$col2[order(z3$v5)],
            vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
            pcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),NA) , pfcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),'white'))
}
dev.off()

png('figs/paper/fig3b_1tcell.png',width = 10, height = 10, units = 'in',res = 300)
{data1=data02[grep('T_cell',rownames(data02)),]
set.seed(123)
camp=sample(1:nrow(data1),16)[2]

data=as.data.frame(rbind(rep_len(max(data02),ncol(data1)),
                         rep_len(min(data02),ncol(data1)),
                         data1[camp,],
                         rep_len(min(data02),ncol(data1))
))  
par(mar=c(0,0,0,0))
radarchart4(data[,z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
            vlabelscol =z3$col2[order(z3$v5)],
            vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
            pcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),NA) , pfcol=c(scales::alpha((viridis::plasma(1)),alpha = 1),'white'))
}
dev.off()

#it takes several minutes
png('figs/paper/fig3b_alltcell.png',width = 10, height = 10, units = 'in',res = 300)
{data1=data02[grep('T_cell',rownames(data02)),]

data=as.data.frame(rbind(rep_len(max(data02),ncol(data1)),
                         rep_len(min(data02),ncol(data1)),
                         data1,
                         rep_len(min(data02),ncol(data1))
))  
par(mar=c(0,0,0,0))
radarchart4(data[,z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
            vlabelscol =z3$col2[order(z3$v5)],
            vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
            pcol=c(scales::alpha((viridis::plasma(nrow(data)-3)),alpha = .3),NA) , pfcol=c(scales::alpha((viridis::plasma(nrow(data)-3)),alpha = .3),'white'))
}
dev.off()

#it takes several minutes
png('figs/paper/fig3b_allfibro.png',width = 10, height = 10, units = 'in',res = 300)
{data1=data02[grep('fibro',ignore.case = T,rownames(data02)),]

data=as.data.frame(rbind(rep_len(max(data02),ncol(data1)),
                         rep_len(min(data02),ncol(data1)),
                         data1,
                         rep_len(min(data02),ncol(data1))))  
par(mar=c(0,0,0,0))
radarchart4(data[,z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
            vlabelscol =z3$col2[order(z3$v5)],
            vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
            pcol=c(scales::alpha((viridis::plasma(nrow(data)-3)),alpha = .3),NA) , pfcol=c(scales::alpha((viridis::plasma(nrow(data)-3)),alpha = .3),'white'))
}
dev.off()


png('figs/paper/fig3C_malignant.png',width = 10, height = 10, units = 'in',res = 300)
{i='LIHC'
  par(mar=c(0,0,0,0))
  tum=a5_short_celltype_df[a5_short_celltype_df$tum==i,]
  #1
  camp=tum[tum$sample==unique(tum$sample)[1],]
  data=data_pat_sc[camp$cell_name[grep('Malignant',camp$cell_type)],]
  data=rbind(rep_len(max(data),ncol(data)),
             rep_len(min(data),ncol(data)),
             data,
             rep_len(min(data),ncol(data)))
  par(mar=c(0,0,0,0))
  radarchart4(data,vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
              vlabelscol =z3$col2[order(z3$v5)],
              vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
              pcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),NA) , pfcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),'white'))
}
dev.off()


png('figs/paper/fig3C_nonmalignant.png',width = 10, height = 10, units = 'in',res = 300)
{i='LIHC'
  par(mar=c(0,0,0,0))
  tum=a5_short_celltype_df[a5_short_celltype_df$tum==i,]
  #1
  camp=tum[tum$sample==unique(tum$sample)[1],]
  data=data_pat_sc[camp$cell_name[grep('Malignant',invert = T,camp$cell_type)],]
  data=rbind(rep_len(max(data),ncol(data)),
             rep_len(min(data),ncol(data)),
             data,
             rep_len(min(data),ncol(data)))
  par(mar=c(0,0,0,0))
  radarchart4(data,vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
              vlabelscol =z3$col2[order(z3$v5)],
              vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
              pcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),NA) , pfcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),'white'))
}

dev.off()

png('figs/paper/fig3C_full.png',width = 10, height = 10, units = 'in',res = 300)
{i='LIHC'
  par(mar=c(0,0,0,0))
  tum=a5_short_celltype_df[a5_short_celltype_df$tum==i,]
  #1
  camp=tum[tum$sample==unique(tum$sample)[1],]
  data=data_pat_sc[camp$cell_name,]
  data=rbind(rep_len(max(data),ncol(data)),
             rep_len(min(data),ncol(data)),
             data,
             rep_len(min(data),ncol(data)))
  par(mar=c(0,0,0,0))
  radarchart4(data,vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
              vlabelscol =z3$col2[order(z3$v5)],
              vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
              pcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),NA) , pfcol=c(scales::alpha(viridis::plasma(nrow(data)-3),alpha = .3),'white'))
  
}
dev.off()


png('figs/paper/figS6A.png',width = 20, height = 10, units = 'in',res = 600)
{
  par(mar=c(0,0,0,0))
  par(mfrow=c(2,4))
  n=1
  set.seed(123)
  data1=data02[grep('T_cell',rownames(data02)),]
  
  camp=sample(1:nrow(data1),8)
  
  data=as.data.frame(rbind(rep_len(max(data02),ncol(data1)),
                           rep_len(min(data02),ncol(data1)),
                           data1[camp,],
                           rep_len(min(data02),ncol(data1))))  
  
  for(i in 1:8){
    print(i)
    # cz=col_annot[rownames(data0_sc),]
    # cz=cz[cz$cell_type==a[i,1],]
    # cz=cz[grep(a[i,2],fixed = F,invert = T,cz$sample),]
    # al=1/table(col_annot$cell_type==x)
    # if(al<.1){al=.1}
    
    al=.1
    par(mar=c(0,0,0,0))
    radarchart4(data[c(1:2,2+i,nrow(data)),z3$v1[order(z3$v5)]],vlabels ='.'  ,cglcol=scales::alpha(z3$col2[order(z3$v5)],.9), cglty=1, axislabcol="black",caxislabels=seq(0,255,64),plwd=1 , plty=1,vlcex = 4,vlcex2 = 4,calcex = 1.5, 
                vlabelscol =z3$col2[order(z3$v5)],
                vlabelscol2 =f_colore_vi(z3$v2),vlabels2 ='.',
                pcol=c(viridis::plasma(5)[1],NA) , pfcol=c( viridis::plasma(5)[1],'white'))
    
    
    # text(x=0,y=0,cex=10,names(data0)[i], col='black',adj = 0.5)
    n=n+1
  }
}
dev.off()



pdf('figs/paper/figS7A.pdf',height = 10,width = 10)
{
col2=c('maroon1',#brca
       'cyan',#coadread
       'plum',#lung
       'orange3',#ov
       'lightsteelblue4'#paad
       
)
names(col2)=c("BRCA","COADREAD",'LUNG','OV','PAAD')

annot_col=list(Trajectory = c('brown','burlywood','tomato','lightsalmon','thistle','darkolivegreen','dodgerblue','deepskyblue','blue','navy'),tum=col2,
               cell_type=c('#E69F00','#56B4E9'))
names(annot_col$Trajectory)=as.factor(gsub('trajectory..|trajectory','',fixed = F,unique(sort(z3$Main_trajectory_refined_by_cluster))))
names(annot_col$tum)=as.factor(names(col2))
names(annot_col$cell_type)=c('Fibroblast','T_cell')
ac=data.frame(Trajectory=gsub('trajectory..|trajectory','',fixed = F,z3$Main_trajectory_refined_by_cluster),row.names = z3$v1, stringsAsFactors = T)

ar=data.frame(tum=unlist(lapply(strsplit(rownames(data02),'__'),'[',1)),cell_type=unlist(lapply(strsplit(rownames(data02),'__'),'[',2)), row.names = rownames(data02),stringsAsFactors = T)

data02_df_01=t(apply(t(data02), 2, normalize))
pheatmap::pheatmap(data02_df_01[c(grep('T_cell',rownames(data02_df_01)),grep('Fibroblast', rownames(data02_df_01))),z3$v1[order(z3$v5)]], cluster_rows = F, cluster_cols = F,show_colnames = F,show_rownames = F,
                   annotation_colors = annot_col,
                   annotation_col = ac,
                   annotation_row = ar, 
                   main = 'T Cells and Fibroblasts')
}
dev.off()


