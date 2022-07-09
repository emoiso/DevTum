#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Aug 31 04:23:00 2021

@author: enrico
Credits to Salil; StackOverflow users lucidv01d & ogrisel and scikit-learn.org examples

"""

import sys
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import os as os
import re as re


from sklearn.metrics import roc_curve, auc
from sklearn.metrics import roc_auc_score

os.chdir('/home/enrico/Documenti/ME@MIT/Pdevtum/classifier_nn/pseudo_test')

path='/home/enrico/Documenti/ME@MIT/Pdevtum/classifier_nn/pseudo_test/tn'
n_classes = 17

x=[]
y=[]
z=[]
for a in range(11):
    score=np.genfromtxt(path+'/res/'+sorted(os.listdir(path+'/res'))[a], dtype=float,delimiter=',')
    test=np.genfromtxt(path+'/answ/'+sorted(os.listdir(path+'/answ'))[a], dtype=int,delimiter=',')
    conf=np.genfromtxt(path+'/conf/'+sorted(os.listdir(path+'/conf'))[a], dtype=int,delimiter=',')
    #fpr = dict()
    #tpr = dict()
    #thresholds = dict()
    #roc_auc = dict()
    #for i in range(n_classes):
    #    fpr[i], tpr[i], _ = roc_curve(test[:, i], score[:, i])
    #    roc_auc[i] = auc(fpr[i], tpr[i])
    fpr, tpr, _ = roc_curve(test.ravel(), score.ravel())
    roc_auc = auc(fpr, tpr)
    x.append(fpr)
    y.append(tpr)
    z.append(roc_auc)

plt.figure()
lw = 2
c = np.arange(2, len(x) + 2)
norm = matplotlib.colors.Normalize(vmin=c.min(), vmax=c.max())
cmap = matplotlib.cm.ScalarMappable(norm=norm,cmap='Blues')
cmap.set_array([])
for a in range(len(x)):
    plt.plot(x[a], y[a], c=cmap.to_rgba(a + 3),lw=lw )
    plt.text(.85, 0.01+(a*.7)/10, str(round(a*.1,1))+' : '+str(round(z[a],2)), fontsize = 8,color=cmap.to_rgba(a + 3))
plt.plot([0, 1], [0, 1], color='lightgray', lw=lw, linestyle='--')
plt.xlim([-0.02, 1.0])
plt.ylim([0.0, 1.05])
plt.text(.85,0.78, 'Purity : AUC', fontsize = 8,color=cmap.to_rgba(13))
plt.text(.05,.9, 'TCGA', fontsize = 8,color=cmap.to_rgba(13))
#plt.xlabel('False Positive Rate')
#plt.ylabel('True Positive Rate')
#plt.title('ROC Curve:  MLP Classifier')
#plt.legend(loc="lower right")
plt.savefig("tn_ROC_multi.pdf")
plt.show()

path='/home/enrico/Documenti/ME@MIT/Pdevtum/classifier_nn/pseudo_test/3ca'
n_classes = 13

x=[]
y=[]
z=[]
for a in range(11):
    score=np.genfromtxt(path+'/res/'+sorted(os.listdir(path+'/res'))[a], dtype=float,delimiter=',')
    test=np.genfromtxt(path+'/answ/'+sorted(os.listdir(path+'/answ'))[a], dtype=int,delimiter=',')
    conf=np.genfromtxt(path+'/conf/'+sorted(os.listdir(path+'/conf'))[a], dtype=int,delimiter=',')
    #fpr = dict()
    #tpr = dict()
    #thresholds = dict()
    #roc_auc = dict()
    #for i in range(n_classes):
    #    fpr[i], tpr[i], _ = roc_curve(test[:, i], score[:, i])
    #    roc_auc[i] = auc(fpr[i], tpr[i])
    fpr, tpr, _ = roc_curve(test.ravel(), score.ravel())
    roc_auc = auc(fpr, tpr)
    x.append(fpr)
    y.append(tpr)
    z.append(roc_auc)

plt.figure()
lw = 2
c = np.arange(2, len(x) + 2)
norm = matplotlib.colors.Normalize(vmin=c.min(), vmax=c.max())
cmap = matplotlib.cm.ScalarMappable(norm=norm,cmap='Blues')
cmap.set_array([])
for a in range(len(x)):
    plt.plot(x[a], y[a], c=cmap.to_rgba(a + 3),lw=lw )
    plt.text(.85, 0.01+(a*.7)/10, str(round(a*.1,1))+' : '+str(round(z[a],2)), fontsize = 8,color=cmap.to_rgba(a + 3))
plt.plot([0, 1], [0, 1], color='lightgray', lw=lw, linestyle='--')
plt.xlim([-0.02, 1.0])
plt.ylim([0.0, 1.05])
plt.text(.85,0.78, 'Purity : AUC', fontsize = 8,color=cmap.to_rgba(13))
plt.text(.05,.9, '3CA', fontsize = 8,color=cmap.to_rgba(13))
#plt.xlabel('False Positive Rate')
#plt.ylabel('True Positive Rate')
#plt.title('ROC Curve:  MLP Classifier')
#plt.legend(loc="lower right")
plt.savefig("3ca_ROC_multi.pdf")
plt.show()
