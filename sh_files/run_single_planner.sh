#!/bin/zsh
echo 'nv' | sudo -S chmod 777 /dev/tty* & sleep 1;
export DRONE_ID=0;
source devel/setup.zsh;
roslaunch diff_planner run_exp_single_lio.launch & sleep 3;
roslaunch diff_planner exp_rviz.launch & sleep 1;
wait;
