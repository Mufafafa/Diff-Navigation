#!/bin/zsh
echo 'nv' | sudo -S chmod 777 /dev/tty* & sleep 1;
export DRONE_ID=0;
# roslaunch mavros px4.launch & sleep 2;
roslaunch mavros px4.launch 2>&1 | grep -v "HP: requesting home position" & sleep 2;
rosrun mavros mavcmd long 511 31 5000 0 0 0 0 0 & sleep 1;   # ATTITUDE_QUATERNION
rosrun mavros mavcmd long 511 105 5000 0 0 0 0 0 & sleep 1;  # HIGHRES_IMU
rosrun mavros mavcmd long 511 83 5000 0 0 0 0 0 & sleep 1;   # ATTITUDE_TARGET
rosrun mavros mavcmd long 511 147 5000 0 0 0 0 0 & sleep 1;  # BATTERY_STATUS
rosrun mavros mavcmd long 511 106 5000 0 0 0 0 0 & sleep 1;  

source ~/Localization_ws/install/setup.zsh;
roslaunch fast_lio lidar.launch & sleep 5;
roslaunch fast_lio initial_align.launch & sleep 8;
roslaunch fast_lio odom_mid360_with_map.launch & sleep 8;
source ~/Diff-Planner/devel/setup.zsh;
roslaunch ekf ekf_lidar.launch & sleep 5;
roslaunch diff_planner exp_rviz.launch & sleep 1;
wait;
