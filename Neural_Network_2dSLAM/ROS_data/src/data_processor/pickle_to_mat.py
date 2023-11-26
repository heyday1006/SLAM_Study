import csv
import matplotlib.pyplot as plt
import numpy as np
import ast
import os
import pandas as pd
import pickle
import scipy.io

dir_path = os.path.dirname(os.path.realpath(__file__))
data_rels=[]
with open(dir_path+'/data_pickle/range_pairs.pickle', 'rb') as handle:
    temp = pickle.load(handle)
    data_rels.append(temp)

scipy.io.savemat('./range_pairs.mat', mdict={'data_rels': data_rels})
    
