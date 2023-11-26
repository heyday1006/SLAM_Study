This package works to:
1. Regulate the frequency of laser range data and robot dynamics to 10 Hz, by using ROS topics throttler (git clone https://github.com/ros/ros_comm.git first, check http://wiki.ros.org/topic_tools/throttle) and message filter (http://wiki.ros.org/message_filters).<br />
And save the data to csv file. <br />
$ roslaunch data_read dataReader.py

2. Process the saved data such that the frequency is adjusted to 2Hz, 1Hz, 0.5Hz. 
    Convert the data in a format of {2 laser range (2,1081)+1 transformation (3)}.<br />
    $ python data_read/src/data_processor/dataProcessing.py<br />
    $ python data_read/src/data_processor/csv_to_pickle.py<br />

At the end, more than 70k laser sequences are generated and saved to 2 pickle files (range_pairs.pickle, pose_rels.pickle).<br />
The pickle files are stored in:<br />
https://drive.google.com/file/d/1risFeQ_3OprTmYozRji51r1ZzSAWHWaA/view?usp=sharing


