*Notes for ROS*

### Environment setup
* Install ROS Melodic or other distro from the home page.
* Source the distro or add to `~/.bashrc`
```bash
source /opt/ros/<distro>/setup.bash
```
* Check if environment set successfully
```bash
printenv | grep ROS
```
* Create a workspace (to clone a package/program)
```bash
# create a workspace folder any where (e.g. name 'catkin_ws')
mkdir -p catkin_ws/src
cd catkin_ws
# point to the python that you're using (use `which python` to know the root path)
catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3
```
* Link the created work space to ROS environment
```bash
cd catkin_ws
source devel/setup.bash
```

### Launch a node / multiple nodes
`roslaunch` and `rosrun`, both can be used to launch nodes. `roslaunch` requires a `.launch` file to launch multiple nodes and pipe the output to a log file.
```bash
roslaunch <package> <abc.launch>
# or
rosrun <package> <node>
```

### rviz
`rviz` could be use to visualise the robot's path in 3D space. The display config could be used to custom the display.
```bash
rosrun rviz rviz -d /path/to/custom_display_config.rviz
```

