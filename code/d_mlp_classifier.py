#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Feb 28 00:01:50 2020

@author: enrico moiso
@version: 5.1
"""
import sys
import numpy as np
from sklearn import preprocessing # solo con vecchio scikit
from sklearn.preprocessing import OneHotEncoder
from keras.models import Sequential
from keras.layers import Dense
from keras.callbacks import EarlyStopping

train=sys.argv[1]
test=sys.argv[2]
num1=int(sys.argv[3])
out=open(sys.argv[4],'a')
val=sys.argv[5]
out2=sys.argv[6]
out3=sys.argv[7]
out4=sys.argv[8]
out5=sys.argv[9]

#train set preparation
X1 = np.loadtxt(train,usecols=range(num1) , delimiter=',')
Y1= np.loadtxt(train, usecols=[num1],dtype='str',delimiter=',')
nclass=len(np.unique(Y1))
le = preprocessing.LabelEncoder()
le.fit(Y1)
Y1=le.transform(Y1)
enc=OneHotEncoder(handle_unknown='ignore')
Y1=enc.fit_transform(Y1.reshape(-1,1)).toarray()
#test  set preparation
Tx1 = np.loadtxt(test,usecols=range(num1) , delimiter=',')
Ty1= np.loadtxt(test, usecols=[num1],dtype='str',delimiter=',')
le.fit(Ty1)
Ty1=le.transform(Ty1)
Ty1=enc.fit_transform(Ty1.reshape(-1,1)).toarray()
#model creation
early_stopping_monitor = EarlyStopping(patience=5)
n_feat=X1.shape[1]
model9=Sequential()
model9.add(Dense(800,activation='relu',input_shape=(n_feat,)))
model9.add(Dense(200,activation='relu'))
model9.add(Dense(nclass))
model9.compile(optimizer='sgd', loss='mean_squared_error',metrics=['accuracy'])
model9.fit(X1, Y1, validation_split=0, epochs=300, callbacks=[early_stopping_monitor])
_,accuracy_pred9 = model9.evaluate(Tx1, Ty1)
test_prediction=model9.predict(Tx1)
model9.save(out2)
print(accuracy_pred9*100 , file = out)
#validation set preparation and testing
val=np.loadtxt(val,usecols=range(num1) , delimiter=',')
val_prediction=model9.predict(val)
train_prediction=model9.predict(X1)
#results export
np.savetxt(out5, train_prediction,delimiter=",",fmt='%s')
np.savetxt(out3,test_prediction, delimiter=",",fmt='%s')
np.savetxt(out4, val_prediction, delimiter=",",fmt='%s')
