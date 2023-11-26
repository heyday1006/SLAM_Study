import csv
import matplotlib.pyplot as plt
import numpy as np
import ast
import os

dir_path = os.path.dirname(os.path.realpath(__file__))
world_name='largeMap'
file_name='/data/'+world_name+'.csv'
newfile_name='/'+world_name+'_processed.csv'
def frequency_convert(pose_j,pose_jc):
    pose_delta=[]
    [x_j,y_j,yaw_j]=pose_j
    [x_jc,y_jc,yaw_jc]=pose_jc
    x_delta=(x_jc-x_j)*np.cos(yaw_j) + (y_jc-y_j)*np.sin(yaw_j)
    y_delta=(y_jc-y_j)*np.cos(yaw_j) - (x_jc-x_j)*np.sin(yaw_j)
    yaw_delta=yaw_jc-yaw_j
    return [x_delta,y_delta,yaw_delta]
    
#store range and pose to lists
poses=[]
lasers=[]
count=0
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

#store data with new frequency to csv file
csvFile=open(dir_path+newfile_name, 'w')
writer = csv.writer(csvFile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

freq_list=[5,10,20,-5,-10,-20]
for freq in freq_list:
    print(max(0,-freq),len(poses)-max(0,freq))
    for idx in range(max(0,-freq),len(poses)-max(0,freq)):
        laser_j=lasers[idx]
        laser_jc=lasers[idx+freq]
        pose_delta=frequency_convert(poses[idx],poses[idx+freq])
        writer.writerow([[laser_j,laser_jc],pose_delta])

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
