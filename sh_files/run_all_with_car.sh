#!/bin/zsh
echo 'nv' | sudo -S chmod 777 /dev/tty* & sleep 1;
# 设置三个标志的位置
export LANDMARK_0_POS="[2.49, 0.10, 0.91]";
export LANDMARK_1_POS="[2.54, -1.26, 0.88]";
#export LANDMARK_2_POS="[3.25, 0.75, 0.75]";
# 设置灭火区偏移量, car = 0.4, dog = 0.5
export FIRE_ZONE_X_OFFSET="0.4";

# roslaunch mavros px4.launch & sleep 2;
roslaunch mavros px4.launch 2>&1 | grep -v "HP: requesting home position" & sleep 2;
rosrun mavros mavcmd long 511 31 5000 0 0 0 0 0 & sleep 1;   # ATTITUDE_QUATERNION
rosrun mavros mavcmd long 511 105 5000 0 0 0 0 0 & sleep 1;  # HIGHRES_IMU
rosrun mavros mavcmd long 511 83 5000 0 0 0 0 0 & sleep 1;   # ATTITUDE_TARGET
rosrun mavros mavcmd long 511 147 5000 0 0 0 0 0 & sleep 1;  # BATTERY_STATUS
rosrun mavros mavcmd long 511 106 5000 0 0 0 0 0 & sleep 1;  

# 启动 swarm_bridge
source ~/swarm_bridge/devel/setup.zsh;
roslaunch swarm_bridge bridge_tcp_drone.launch  & sleep 2;

source ~/Localization_ws/install/setup.zsh;
roslaunch fast_lio lidar.launch & sleep 5;
roslaunch fast_lio initial_align.launch & sleep 8;
roslaunch fast_lio odom_mid360_with_map.launch & sleep 8;

source ~/Diff-Planner/devel/setup.zsh;
roslaunch ekf ekf_lidar.launch & sleep 5;
roslaunch diff_planner run_exp_single_lio.launch & sleep 3;
roslaunch px4ctrl run_ctrl_lio.launch & sleep 3;
roslaunch multipoint multipointplan_exp_lio.launch & sleep 2;
# roslaunch diff_planner exp_rviz.launch & sleep 1;

source ~/yolo_ws/devel/setup.zsh;
roslaunch recognition yolo_detection_with_world_coords.launch \
    landmark_0_pos:="${LANDMARK_0_POS}" \
    landmark_1_pos:="${LANDMARK_1_POS}" \
    fire_zone_x_offset:="${FIRE_ZONE_X_OFFSET}"

wait;
