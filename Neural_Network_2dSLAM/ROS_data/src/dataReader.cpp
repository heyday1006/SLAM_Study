#include <ros/ros.h> 
#include <sensor_msgs/LaserScan.h>
#include <nav_msgs/Odometry.h>
#include <message_filters/subscriber.h>
#include <message_filters/synchronizer.h>
#include <message_filters/sync_policies/approximate_time.h>

using namespace message_filters;

void subCallback(const sensor_msgs::LaserScan::ConstPtr& msg_1,const nav_msgs::Odometry::ConstPtr& msg_2){
    ROS_INFO_STREAM("hello");
}
int main(int argc, char** argv) {
    ros::init(argc, argv, "scan_values");
    ros::NodeHandle nh;
    message_filters::Subscriber<sensor_msgs::LaserScan> f_sub(nh, "/robot_1/base_scan", 1);
    message_filters::Subscriber<nav_msgs::Odometry> s_sub(nh, "robot_1/odom", 1);
	ROS_INFO_STREAM("hello");
    typedef sync_policies::ApproximateTime<sensor_msgs::LaserScan, nav_msgs::Odometry> MySyncPolicy;

    Synchronizer<MySyncPolicy> sync(MySyncPolicy(40), f_sub, s_sub);
    sync.registerCallback(boost::bind(&subCallback, _1, _2));
    ros::spin();
    return 0;
}
