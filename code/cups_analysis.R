load('/home/enrico/Documenti/ME@MIT/Pdevtum/classifier_nn/tcga_nontcga_mgh_rankyes_nonnorm.rsave')
load('/home/enrico/Documenti/ME@MIT/Pdevtum/classifier_nn/campioni_tcga_nontcga_mgh.rsave')
cup2=read.csv('/home/enrico/Documenti/ME@MIT/Pdevtum/mouse_tissue_atlas/CUP/cup_2_deconvo.csv',stringsAsFactors = F,check.names = F)
cup1=tcga_nontcga_mgh_rankyes_nonnorm[campioni$sample[campioni$tum2=='CUP'],]
cup1_sel=as.character(c('059','045','033','037','049','061','065','058','062','068','042','040','064','038','054','046','063','057','055','056'))
cup1=cup1[grep(paste0(cup1_sel,collapse='|'),rownames(cup1)),]
cup2_id=read.csv('/home/enrico/Documenti/ME@MIT/Pdevtum/mouse_tissue_atlas/CUP/cup2_id.csv',stringsAsFactors = F,check.names = F, header = F)
library(xlsx)
cup2_meta=read.xlsx('/home/enrico/Documenti/ME@MIT/Pdevtum/mouse_tissue_atlas/CUP/Pull_list_Garglab_1-22.xlsx',sheetIndex = 1,as.data.frame = T)
for(i in 1:3){cup2_meta[,i]=as.character(cup2_meta[,i])}
cup2_meta=merge(cup2_meta,cup2_id,by.x=1,by.y=2)
rownames(cup2)=gsub('-5670F','',rownames(cup2))
cup2=cup2[cup2_meta$V1[cup2_meta$Study=='CUP'],]
cups=rbind(cup1, cup2)
rownames(cups)=gsub('-4694R$','',fixed = F,gsub('^','MGH',gsub('D20-24|-5670F|D22-15','',fixed = F,rownames(cups))))
cups_sc=scale(cups[,])#-31
cups_sc[is.na(cups_sc)]=0
cups_sc2=scale(cups)
quantile_breaks <- function(xs, n = 10) {
  breaks <- quantile(xs, probs = seq(0, 1, length.out = n), na.rm=T)
  breaks[!duplicated(breaks)]
}

mat_breaks <- quantile_breaks(cups_sc2, n = 11)
my_palette <- c(colorRampPalette(colors = c( "#2D004B","#B4ACC9"))(n = 5),
                "white",
                c(colorRampPalette(colors = c("#DFB88C", "#7F3B08"))(n= 5)))
col3=c('goldenrod4',#ACC
       'mistyrose2',#Blca
       'maroon1',#brca
       'orange',#cesc
       'blue4',#chol
       'cyan',#coadread
       #'grey',#cup
       'indianred',#dlbc
       'dodgerblue',#gbm
       'darkseagreen',#hnsc
       'brown',#kid
       'tan4',#laml
       'lightsteelblue',#lihc
       'plum',#lung
       'purple4',#meso
       'orange3',#ov
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
names(col3)=unique(campioni$tum2[campioni$dataset=='TCGA'])
annot=data.frame(Tumor_types=unique(campioni$tum2[campioni$dataset=='TCGA']), row.names =unique(campioni$tum2[campioni$dataset=='TCGA']), stringsAsFactors = T )
annot_col=list(Tumor_types=col3)
names(annot_cols$Tumor_types)=unique(campioni$tum2[campioni$dataset=='TCGA'])
load('~/Documenti/ME@MIT/Pdevtum/git/DevTum/dep_files/color_annotations.rsave')
p=pheatmap::pheatmap(t(cups_sc2[,z3$v1[order(z3$Main_trajectory_refined_by_cluster,z3$v3,z3$v2)]]),cluster_cols = hclust(amap::Dist(cups_sc,method = 'spearman'), method = 'ward.D'),cluster_rows = F, cutree_cols = 4,
                     show_rownames = F,show_colnames = F, color = my_palette,#rev(brewer.pal(n = 11, name = "PuOr")),
                     annotation_row =  annot,annotation_colors  = annot_col,  treeheight_col = 0,gaps_row = c(29,80,98,105,138,154,176,214),breaks = mat_breaks
)#,legend_breaks = c(-2,0,2),legend_labels = c(-2,0,2))

k=data.frame(k=cutree(hclust(amap::Dist(cups_sc,method = 'spearman'), method = 'ward.D'),k = 4), row.names = rownames(cups_sc))
cups_ddc=lapply(colnames(cups_sc),function(x){
  kruskal.test(cups_sc[,x]~k$k)
})
names(cups_ddc)=colnames(cups_sc)
cups_ddc_pval=lapply(cups_ddc,'[[',3)
cups_ddc_pval=data.frame(pval=unlist(cups_ddc_pval),bonf=p.adjust(unlist(cups_ddc_pval),method = 'bonf',n = length(na.omit(unlist(cups_ddc_pval)))))
rownames(cups_ddc_pval)=colnames(cups_sc)
cups_ddc_pval005=na.omit(cups_ddc_pval[cups_ddc_pval$bonf<.05,])

cups_ddc_pval005$traj=rownames(cups_ddc_pval005)
cups_ddc_pval005$traj2=unlist(lapply(strsplit(rownames(cups_ddc_pval005),'-'),'[',2))
cups_ddc_pval005=merge(cups_ddc_pval005,annotazioni_traj,by.x=4,by.y = 2)


annot=data.frame(Main_trajectory=gsub(' trajectory','',z3$Main_trajectory_refined_by_cluster[order(z3$v5)]), row.names = z3$v1[order(z3$v5)],stringsAsFactors = T)
annot_col=list(Main_trajectory=unique(z3[,c(4,7)])[,2])
names(annot_col$Main_trajectory)=gsub(' trajectory','',unique(z3[,c(4,7)])[,1])



bk1 <- seq(-7,-0.1,by=0.1)
bk2 <- seq(0.1,3.4,by=0.1)
bk <- c(bk1,bk2)  #combine the break limits for purpose of graphing

my_palette <- c(colorRampPalette(colors = c("darkblue", "lightblue"))(n = length(bk1)-1),
                "white", "white",
                c(colorRampPalette(colors = c( "tomato1","darkred"))(n = length(bk2)-1)))

rownames(cups_sc2)=gsub('^','MGH',gsub('D20-24|-5670F|D22-15','',fixed = F,rownames(cups_sc2)))

pdf('/home/enrico/Documenti/ME@MIT/Pdevtum/mouse_tissue_atlas/figs2/figure_paper/supp/cancer_disc/hm_cups_ddc.pdf',width = 15,height = 10)

pheatmap::pheatmap(t(cups_sc2[,cups_ddc_pval005$traj[order(cups_ddc_pval005$Main_trajectory_refined_by_cluster,cups_ddc_pval005$traj2,cups_ddc_pval005$traj)]]),
                   cluster_cols = hclust(amap::Dist(cups_sc,method = 'spearman'), method = 'ward.D'),cluster_rows = F, cutree_cols = 4,
                   show_rownames = T,show_colnames = T,labels_row =gsub('_trajectory','', cups_ddc_pval005$traj[order(cups_ddc_pval005$Main_trajectory_refined_by_cluster,cups_ddc_pval005$traj2,cups_ddc_pval005$traj)])
                   ,labels_col = gsub('^','MGH',gsub('D20-24|-5670F|D22-15','',fixed = F,rownames(cups_sc2))),
                   annotation_row =  annot,annotation_colors  = annot_col,  treeheight_col = 0, breaks = bk, color = my_palette,legend_breaks = c(3,1,0,-1,-3,-5,-7),legend_labels = c(3,1,0,-1,-3,-5,-7))
dev.off()



cups_class_res=read.delim('/home/enrico/Documenti/ME@MIT/Pdevtum/classifier_nn/cups_rev/cups_full_res.array',sep = ',',header = F)

rownames(cups_class_res)=rownames(cups_norm)
colnames(cups_class_res)=unique(campioni$tum2)[-28]

library(RColorBrewer)
# Returns a vector of 'num.colors.in.palette'+1 colors. The first 'cutoff.fraction'
# fraction of the palette interpolates between colors[1] and colors[2], the remainder
# between colors[3] and colors[4]. 'num.colors.in.palette' must be sufficiently large
# to get smooth color gradients.
makeColorRampPalette <- function(colors, cutoff.fraction, num.colors.in.palette)
{
  stopifnot(length(colors) == 4)
  ramp1 <- colorRampPalette(colors[1:2])(num.colors.in.palette * cutoff.fraction)
  ramp2 <- colorRampPalette(colors[3:4])(num.colors.in.palette * (1 - cutoff.fraction))
  return(c(ramp1, ramp2))
}

col3=c('goldenrod4',#ACC
       'mistyrose2',#Blca
       'maroon1',#brca
       'orange',#cesc
       'blue4',#chol
       'cyan',#coadread
       #'grey',#cup
       'indianred',#dlbc
       'dodgerblue',#gbm
       'darkseagreen',#hnsc
       'brown',#kid
       'tan4',#laml
       'lightsteelblue',#lihc
       'plum',#lung
       'purple4',#meso
       'orange3',#ov
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
names(col3)=unique(campioni$tum2[campioni$dataset=='TCGA'])
annot=data.frame(Tumor_types=unique(campioni$tum2[campioni$dataset=='TCGA']), row.names =unique(campioni$tum2[campioni$dataset=='TCGA']), stringsAsFactors = T )
annot_cols=list(Tumor_types=col3)
names(annot_cols$Tumor_types)=unique(campioni$tum2[campioni$dataset=='TCGA'])
cols <- makeColorRampPalette(c(brewer.pal(n=9, name='Greens')[1], brewer.pal(n=9, name='Greens')[5],    # distances 0 to 3 colored from white to red
                               brewer.pal(n=9, name='Greens')[7], brewer.pal(n=9, name='Greens')[9]), # distances 3 to max(distmat) colored from green to black
                             .99 / 1,
                             100)
cups_class_res_norm=apply(t(cups_class_res), 2, normalize)
colnames(cups_class_res_norm)=gsub('^','MGH',gsub('D20-24|-5670F|D22-15','',fixed = F,colnames(cups_class_res_norm)))
pdf('/home/enrico/Documenti/ME@MIT/Pdevtum/mouse_tissue_atlas/figs2/figure_paper/supp/cancer_disc/hm_cups_class.pdf',width = 10,height = 6)
pheatmap::pheatmap(cups_class_res_norm,cluster_rows = F,
                   color = cols, annotation_row =annot , annotation_colors = annot_cols, border_color = NA, angle_col = 270, cluster_cols = hclust(amap::Dist(cups_sc,method = 'spearman'), method = 'ward.D'), cutree_cols = 4, treeheight_col = 0)
dev.off()