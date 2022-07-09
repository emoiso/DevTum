# -*- coding: utf-8 -*-
"""
Created on Thu May 13 12:02:28 2021

@author: Salil
Credits to StackOverflow users lucidv01d & ogrisel and scikit-learn.org examples
"""

import sys
import numpy as np
import matplotlib
import matplotlib.pyplot as plt

from sklearn.metrics import roc_curve, auc
from sklearn.metrics import roc_auc_score

y_score2 = np.genfromtxt('classifier_results.txt', dtype=float)
y_test2 = np.genfromtxt('answers_array.txt', dtype=int)
confusion_matrix = np.genfromtxt('confusion_matrix.txt', dtype=int)

n_classes2 = 27

# Compute ROC curve and ROC area for each class
fpr2 = dict()
tpr2 = dict()
thresholds2 = dict()
roc_auc2 = dict()
for i in range(n_classes2):
    fpr2[i], tpr2[i], _ = roc_curve(y_test2[:, i], y_score2[:, i])
    roc_auc2[i] = auc(fpr2[i], tpr2[i])
    
# Compute micro-average ROC curve and ROC area
fpr2["micro"], tpr2["micro"], thresholds2 = roc_curve(y_test2.ravel(), y_score2.ravel())
roc_auc2["micro"] = auc(fpr2["micro"], tpr2["micro"])

matplotlib.rc('xtick', labelsize=20)
matplotlib.rc('ytick', labelsize=20)

plt.figure()
lw = 5
plt.plot(fpr2["micro"], tpr2["micro"], color='darkblue',
         lw=lw, label='ROC curve (area = %0.4f)' % roc_auc2["micro"])
plt.plot([0, 1], [0, 1], color='grey', lw=lw, linestyle='--')
plt.xlim([-0.02, 1.0])
plt.ylim([0.0, 1.05])
#plt.xlabel('False Positive Rate')
#plt.ylabel('True Positive Rate')
#plt.title('ROC Curve:  MLP Classifier')
#plt.legend(loc="lower right")
plt.savefig("ROC.pdf")
plt.show()

#Bootstrapping to determine the 95% confidence interval for AUC
n_bootstraps = 1000
rng_seed = 28  # control reproducibility
bootstrapped_scores = []

rng = np.random.RandomState(rng_seed)
for i in range(n_bootstraps):
    indices = rng.randint(0, len(y_score2.ravel()), len(y_score2.ravel()))
    if len(np.unique(y_test2.ravel()[indices])) < 2:
        # We need at least one positive and one negative sample for ROC AUC, otherwise reject
        continue

    score = roc_auc_score(y_test2.ravel()[indices], y_score2.ravel()[indices])
    bootstrapped_scores.append(score)

sorted_scores = np.array(bootstrapped_scores)
sorted_scores.sort()
confidence_lower = sorted_scores[int(0.025 * len(sorted_scores))]
confidence_upper = sorted_scores[int(0.975 * len(sorted_scores))]

print("ROC curve area: [{:0.4f}]".format(roc_auc2['micro']))
print("Confidence interval for the score: [{:0.4f} - {:0.4}]".format(
    confidence_lower, confidence_upper))


#Using the confusion matrix to predict sensitivity and specificity for tumor types
FP = confusion_matrix.sum(axis=0) - np.diag(confusion_matrix)  
FN = confusion_matrix.sum(axis=1) - np.diag(confusion_matrix)
TP = np.diag(confusion_matrix)
TN = confusion_matrix.sum() - (FP + FN + TP)

# Sensitivity, hit rate, recall, or true positive rate
TPR = TP/(TP+FN)
# Specificity or true negative rate
TNR = TN/(TN+FP) 
# Precision or positive predictive value
PPV = TP/(TP+FP)
# Negative predictive value
NPV = TN/(TN+FN)
# Fall out or false positive rate
FPR = FP/(FP+TN)
# False negative rate
FNR = FN/(TP+FN)
# False discovery rate
FDR = FP/(TP+FP)

# Overall accuracy
ACC = (TP+TN)/(TP+FP+FN+TN)

original = sys.stdout

with open("output_values2.txt","a") as f:
    for i in range(27):
        sys.stdout = f
        print(TPR[i],'\t',TNR[i],'\t',PPV[i],'\t',NPV[i],'\t',FPR[i],'\t',FNR[i],'\t',FDR[i],'\t',ACC[i])

sys.stdout = original
