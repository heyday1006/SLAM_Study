# SLAM_Study

This repository works as a learning process of constructing maps from sparse sensor data.

## [Compressive Sensing and Occupancy Grid Mapping](https://github.com/heyday1006/SLAM_Study/blob/main/Compressive_Sensing_GridMap/Group%20Meeting-07%3A22%3A2020.pdf)

<br />
We use optimization-based compressive sensing technique to reconstruct 2D depth profile, and build a complete map using occupancy grid mapping. 

| CS Reconstruction | Mapping | 
| :-:| :-:| 
| <img src = "Compressive_Sensing_GridMap/img/cs_reconstruction.png" width=400> | <img src = "Compressive_Sensing_GridMap/img/output.gif" width=500> | 


## [Deep Learning Approach on 2D SLAM](https://github.com/heyday1006/SLAM_Study/edit/main/Neural_Network_2dSLAM/README.md) 

<br />
We created diverse Gazebo worlds, brought up a Kobuki robot equipped with laser scanners, then used the ROS package on RRT-based map exploration to collect data. 

- We solved the relative pose prediction problem via a multi-task regression model, and loop closure detection problem via a binary classification model.

- To create the pose regression dataset, we subsample the data to a frequency of {2Hz, 1Hz, 0.5Hz}. In total, there are more than 150k pairs for training+validation+testing (fraction: 0.99x0.85:0.99x0.15:0.01, see training environment) and 30k pairs for extra testing (see testing environment). 

- To create the loop closure dataset, we define the closure condition as: norm of the relative translation is less than 0.3m and the absolute value of the relative rotation is less than 100 degrees. There are more than 240k pairs for training+validation+testing(fraction: 0.99x0.85:0.99x0.15:0.01) and 40k for extra testing. Overall, the positive rate of the training dataset is 44.5%.

- From the pose regressor, the estimate trajectory from only odometry (scan matching) can be obtained. We then used closure detection model to find out the closures. The relative constraints were added to the pose graph to implement Pose Graph Optimization.


 | Gazebo | Trajectory | Gazebo | Trajectory |
| :-:| :-:| :-: | :-:|
|simple wall<br /> <img src = "Neural_Network_2dSLAM/plot/world/simple_wall.png" height=150 width=150> | <img src = "Neural_Network_2dSLAM/plot/simple_wall.png" width=300> | custom office 2<br /> <img src = "Neural_Network_2dSLAM/plot/world/custom_office2.png" height=150 width=150> | <img src = "Neural_Network_2dSLAM/plot/custom_officetwo1.png" width=300> |
|MTR <br /> <img src = "Neural_Network_2dSLAM/plot/world/MTR.png" height=150 width=150> | <img src = "Neural_Network_2dSLAM/plot/MTR.png" width=300> | house <img src = "Neural_Network_2dSLAM/plot/world/house.png" height=150 width=150> | <img src = "Neural_Network_2dSLAM/plot/house.png" width=300> | 
|large map <br /><img src = "Neural_Network_2dSLAM/plot/world/largeWorld.png" height=150 width=150> | <img src = "Neural_Network_2dSLAM/plot/largeMap.png" width=300> | custom office 3 <br /><img src = "Neural_Network_2dSLAM/plot/world/custom_office3.png" height=150 width=150> | <img src = "Neural_Network_2dSLAM/plot/custom_officethree1.png" width=300> |


