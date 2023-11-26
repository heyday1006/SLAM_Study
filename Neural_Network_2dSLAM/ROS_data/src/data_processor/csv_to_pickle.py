import csv
import matplotlib.pyplot as plt
import numpy as np
import ast
import os
import pandas as pd
import pickle

dir_path = os.path.dirname(os.path.realpath(__file__))

range_pairs=[]
pose_rels=[]
world_list=['simple_maze','simple_wall','cloister','house','MTR','largeMap']
for world in world_list:
    file_name='/data_processed/'+world+'_processed.csv'
    with open(dir_path+file_name, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        for row in reader:
            laser=list(ast.literal_eval(row[0].replace('inf','2e308')))
            pose=list(ast.literal_eval(row[1]))
            range_pairs.append(laser)
            pose_rels.append(pose)
    print('world: '+world+' DONE!')
range_pairs=np.array(range_pairs)
pose_rels=np.array(pose_rels)
print('shape of range_pairs: ', range_pairs.shape)
print('shape of pose_rels: ', pose_rels.shape)

with open(dir_path+'/range_pairs.pickle', 'wb') as handle:
    pickle.dump(range_pairs, handle, protocol=pickle.HIGHEST_PROTOCOL)

with open(dir_path+'/pose_rels.pickle', 'wb') as handle:
    pickle.dump(pose_rels, handle, protocol=pickle.HIGHEST_PROTOCOL)
