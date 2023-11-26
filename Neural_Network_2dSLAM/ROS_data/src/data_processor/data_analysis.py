import pickle
from sklearn.utils import shuffle
import numpy as np
import matplotlib.pyplot as plt

with open('data_pickle/pose_rels.pickle', 'rb') as handle:
    pose_rels = pickle.load(handle)
print("size of pose_rels: ", pose_rels.shape)

ys = shuffle(pose_rels) #shuffling the dataset

percent_of_trainSet=0.9*0.8
percent_of_validationSet=0.9*0.2
percent_of_testSet=0.1
num_of_trainSet=np.int(ys.shape[0]*percent_of_trainSet)
num_of_validationSet=np.int(ys.shape[0]*percent_of_validationSet)
num_of_testSet=np.int(ys.shape[0]*percent_of_testSet)


y_training = np.array(ys[0:num_of_trainSet], dtype=float)
print('Size of training labels: ',y_training.shape)
y_validation = np.array(ys[num_of_trainSet:num_of_trainSet+num_of_validationSet], dtype=float)
print('Size of validation labels: ',y_validation.shape)
y_testing = np.array(ys[num_of_trainSet+num_of_validationSet:], dtype=float)
print('Size of testing labels: ',y_testing.shape)

# equivalent but more general
ax1=plt.subplot(2,2,1)
ax1.set_title('data')
ax1.scatter(y_training[:,0],y_training[:,1],s=1)

ax2=plt.subplot(2,2,2)
ax2.set_title('x')
ax2.boxplot(y_training[:,0], showfliers=False)

ax3=plt.subplot(2,2,3)
ax3.set_title('y')
ax3.boxplot(y_training[:,1], showfliers=False)

ax4=plt.subplot(2,2,4)
ax4.set_title('theta')
ax4.boxplot(y_training[:,2], showfliers=False)

plt.show()
