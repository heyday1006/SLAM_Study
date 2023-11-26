import csv
import matplotlib.pyplot as plt
import numpy as np
import ast
import os
import pickle


dir_path = os.path.dirname(os.path.realpath(__file__))

def edge_angle(yaw_j,yaw_jc):
    heading_j=np.array([[np.cos(yaw_j),np.sin(yaw_j)]]).T
    heading_jc=np.array([[np.cos(yaw_jc),np.sin(yaw_jc)]]).T
    cAngle=np.dot(heading_j.T,heading_jc)
    sAngle=np.dot(np.array([[0,0,1]]),np.cross(np.append(heading_j,0),np.append(heading_jc,0)))
    #print(np.shape(cAngle),np.shape(sAngle))
    edgeAngle=np.arctan2(sAngle,cAngle)
    return edgeAngle
    
def frequency_convert(pose_j,pose_jc):
    pose_delta=[]
    [x_j,y_j,yaw_j]=pose_j
    [x_jc,y_jc,yaw_jc]=pose_jc
    x_delta=(x_jc-x_j)*np.cos(yaw_j) + (y_jc-y_j)*np.sin(yaw_j)
    y_delta=(y_jc-y_j)*np.cos(yaw_j) - (x_jc-x_j)*np.sin(yaw_j)
    yaw_delta=edge_angle(yaw_j,yaw_jc)
    return [x_delta,y_delta,yaw_delta]
    
range_pairs=[]
pose_rels=[]
world_list=['simple_maze','simple_wall','cloister','house','MTR','largeMap']
for world in world_list:
    file_name='/data/'+world+'.csv'
    #store range and pose to lists
    poses=[]
    lasers=[]
    print('process world: '+world)
    with open(dir_path+file_name) as csv_file:
        plots = csv.reader(csv_file, delimiter=',')
        for row in plots:
            laser=list(ast.literal_eval(row[0].replace('inf','2e308')))
    #        if count==1886: #to analyse data with 'inf'
    #            print(laser)
    #            break
            pose=list(ast.literal_eval(row[1]))
            lasers.append(laser)#[round(item,5) for item in range])
            poses.append(pose)#[round(item,5) for item in pose])
    #        count+=1
    #        print(count)
    print("length of sequence: ", len(poses))
    

    freq_list=[5,10,20,-5,-10,-20]
    for freq in freq_list:
        print(max(0,-freq),len(poses)-max(0,freq))
        for idx in range(max(0,-freq),len(poses)-max(0,freq)):
            laser_j=lasers[idx]
            laser_jc=lasers[idx+freq]
            pose_delta=frequency_convert(poses[idx],poses[idx+freq])
#            writer.writerow([[laser_j,laser_jc],pose_delta])
            range_pairs.append([laser_j,laser_jc])
            pose_rels.append(pose_delta)
    print('world: '+world+' DONE!')

range_pairs=np.array(range_pairs)
pose_rels=np.array(pose_rels)
print('shape of range_pairs: ', range_pairs.shape)
print('shape of pose_rels: ', pose_rels.shape)

with open(dir_path+'/range_pairs.pickle', 'wb') as handle:
    pickle.dump(range_pairs, handle, protocol=pickle.HIGHEST_PROTOCOL)

with open(dir_path+'/pose_rels.pickle', 'wb') as handle:
    pickle.dump(pose_rels, handle, protocol=pickle.HIGHEST_PROTOCOL)

#poses=[]
#with open(dir_path+newfile_name) as csv_file:
#    plots = csv.reader(csv_file, delimiter=',')
#    for row in plots:
#        poses.append(row[1])
#        print(row[1])
#        laser=np.array(ast.literal_eval(row[0]))
#        #print(laser[1,0:5])

#plt.plot(x,y, label='Loaded from file!')
#plt.xlabel('x')
#plt.ylabel('y')
#plt.title('Robot Trajectory')
#plt.legend()
#plt.savefig('MTR.png')
#plt.show()
