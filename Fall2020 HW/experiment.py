#!/usr/bin/env python
# coding: utf-8

# # Regression with Bayesian Approach
# 
# In this experient, we are goint to study the different methods to classify Iris dataset

# Import libraries
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.naive_bayes import GaussianNB
from sklearn.naive_bayes import MultinomialNB
from sklearn.naive_bayes import BernoulliNB
from sklearn.naive_bayes import CategoricalNB
from sklearn import svm

iris = load_iris()
data = iris.data
list(iris.target_names)



df = pd.DataFrame(data, columns=['sepal_length','sepal_width', 'petal_length', 'petal_width'])
df.head()


# In[50]:


sns.pairplot(df,height=3);


# In[49]:


corrMatrix = df.corr()
sns.heatmap(corrMatrix, annot=True)
plt.show()


# ## Experiment

# In[19]:


# Constant
SEED = 42
SPLIT = 0.5


# In[20]:


# load data
X, y = load_iris(return_X_y=True)
# split dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=1-SPLIT, random_state=SEED)


# In[59]:


# Logistic Regression
logreg = LogisticRegression(C=1e5)


# In[60]:


logreg.fit(X_train, y_train)


# In[61]:


y_pred = logreg.predict(X_test)


# In[62]:


print("Logistic Regression Accuracy %.4f" % (1-(y_test != y_pred).sum()/X_test.shape[0]))


# In[21]:


# Gaussian Naive Bayes
gnb = GaussianNB()
y_pred = gnb.fit(X_train, y_train).predict(X_test)


# In[36]:


print("Gaussian Naive Bayes Classifier Accuracy %.4f" % (1-(y_test != y_pred).sum()/X_test.shape[0]))


# In[65]:


# Multinomial Naive Bayes classifier
mnb = MultinomialNB()
y_pred = mnb.fit(X_train, y_train).predict(X_test)


# In[66]:


print("multinomial Naive Bayes classifier Accuracy %.4f" % (1-(y_test != y_pred).sum()/X_test.shape[0]))


# In[76]:


# Linear Support Vector Classification
clf = svm.LinearSVC()
y_pred = clf.fit(X_train, y_train).predict(X_test)


# In[77]:


print("Support Vector Machines Accuracy %.4f" % (1-(y_test != y_pred).sum()/X_test.shape[0]))


# In[ ]:




