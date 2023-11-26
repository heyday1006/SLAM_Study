#! /usr/bin/env python

import rospy
from tf.transformations import euler_from_quaternion
from sensor_msgs.msg import LaserScan
from nav_msgs.msg import Odometry
import message_filters
from time import time
import csv
import os 

dir_path = os.path.dirname(os.path.realpath(__file__))
csvFile=open('/home/heyday1006/trial/src/data_read/src/office.csv', 'w')
writer = csv.writer(csvFile, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)

def callback(laser, msg):
    # Solve all of perception here...
    quaternion=msg.pose.pose.orientation
    explicit_quat = [quaternion.x, quaternion.y, quaternion.z, quaternion.w]
    (roll,pitch,yaw) = euler_from_quaternion(explicit_quat)
    pose=(msg.pose.pose.position.x, msg.pose.pose.position.y, yaw)
    print "------------------------------------------------"
    rospy.loginfo("store info")
    print "len(range)= "+str(len(laser.ranges))
    print "[x,y,theta] = "+str(pose)
    writer.writerow([laser.ranges,pose])


def myhook():
  print "shutdown time!"

rospy.init_node("scan_values")
image_sub = message_filters.Subscriber('/robot_1/range_throttled', LaserScan)
info_sub = message_filters.Subscriber('/robot_1/odom_throttled', Odometry)

ts = message_filters.ApproximateTimeSynchronizer([image_sub, info_sub], 10,0.09)
ts.registerCallback(callback)
rospy.spin()
rospy.on_shutdown(myhook)
