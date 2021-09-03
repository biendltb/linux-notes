messy command logs


```bash

aws configure --profile satis-root

openvpn3 session-start --config ~/bien.ovpn 
aws-vault exec satis-root --no-session aws s3 ls

aws-vault login satis-research 

aws --profile satis-research s3 ls
aws --profile satis-research s3 cp s3://satis-object-detector-models-research/20210422_SATIS-DS-0001_png_darwin_json.zip /data/datasets/satis

Connect to OVH: ssh -i ~/.ssh/satis-engineering-ovh.txt ubuntu@146.59.249.121

ssh -L localhost:8888:localhost:8888 -i ~/satis-research-bien.pem ubuntu@ec2-18-170-28-235.eu-west-2.compute.amazonaws.com

aws --profile satis-manage codeartifact login --tool pip  --domain satis-manage-default --domain-owner 070381681005 --repository satis-artifact-repository-manage-default --region=eu-west-2
-------------------------------------------------
# scp
scp -P 2222 biendltb@dynim.ddns.net:/data/ftp_storage/dynimlabs/stereo-camera/spark/images/buildroot/ubuntu/snapshots/20210621_02/sdcard.img .

GLOBIGNORE="/home/biendltb/Projects/navigation/dynim-image-acquisition-tool/.git:/home/biendltb/Projects/navigation/dynim-image-acquisition-tool/build:"
scp -r /home/biendltb/Projects/navigation/dynim-image-acquisition-tool/* root@192.168.86.34:/usr/src/bien-test/dynim-image-acquisition-tool/

ssh biendltb@dynim.ddns.net -p 2222

PYTHONPATH=$PYTHONPATH:/home/biendltb/Projects/navigation/libsparkproto/build/python

/usr/lib/systemd/system/systemd-sparkcamera-daemon.service


# CMake
cmake -DWITH_IPP=ON -DWITH_QT=OFF -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON -DENABLE_PRECOMPILED_HEADERS=OFF WITH_GTK_2_X=ON -DCMAKE_INSTALL_PREFIX=$HOME/opencv ../opencv-master/

cmake .. -DCMAKE_PREFIX_PATH=$HOME/opencv

# gcc error
apt install libc6-dev

systemctl status systemd-sparkcamera-daemon.service

# gdb
f <stack number>
p <param val>

./i2cio/i2cio read 1 0x36 16/3149
# --> CA (gray) or 4A (color)

systemctl --type=service

make raspberrypi3_64_defconfig
make menuconfig
sudo make all

# umount FIRST
sudo dd bs=1M if=/home/biendltb/Projects/tmp/buildroot/buildroot-2020.02.7/output/images/sdcard.img of=/dev/sdd status=progress

# Press "/" for finding packages/options
make savedefconfig

cat ~/.ros/im_proc_log.txt | sed -n -e 's/^.*\(\[STAT\]\[feature\]: \)//p' > ~/Downloads/shoot_18_features.txt

# tmux scroll
tmux: Ctrl-b then [

catkin_make --pkg msckf_vio --cmake-args -DCMAKE_BUILD_TYPE=Release -DOpenCV_DIR=/opt/opencv/4.1.0/lib/cmake/opencv4

cat ~/.ros/log/latest/rosout.log | sed -n -e 's/^.*\(\[STAT\]\[imu_pose\]: \)//p' > ~/Downloads/stat/shoot_03/stamped_traj_estimate.txt

sudo vi /etc/udev/rules.d/10-xplr.rules
sudo udevadm control --reload

stty -F /dev/ttyUSB0 ispeed 460800 ospeed 460800 -brkint -icrnl -imaxbel -opost -onlcr -icanon -echo -echoe eof ^A min 1 time 0
stty -F /dev/ttyUSB0

vi /etc/default/gpsd 

# To disable GUI on boot, run:
sudo systemctl set-default multi-user.target
# To enable GUI again issue the command: 
sudo systemctl set-default graphical.target

# To start Gnome session on a system without a current GUI just execute:
sudo systemctl start gdm3.service

rosbag record /ocams/image_processor/debug_stereo_image /ocams/vio/odom /ocams/vio/feature_point_cloud

ssh dynimlabs@192.168.86.168

ssh root@192.168.0.119

docker run -itd --mount type=bind,source=$PWD,target=/catkin_ws -v /mnt/6e1ef38e-db2f-4eda-ad11-31252df3b87b/data/Datasets/:/Datasets ros/msckf_vio:v2
docker exec -it zen_leakey bash

sudo screen /dev/ttyUSB1 115200
# to exit: Ctrl + A -> \ -> y

printf '%s\n' "$PWD"/* >filenames.txt

cat ~/.ros/log/latest/rosout.log | grep "Standard deviation" | cut -c233-
./test_vio --path=/media/biendltb/HD1/Datasets/DNS/easy/static_1m &> /dev/stdout | grep "candidate"
cat ~/.ros/log/latest/rosout.log | grep 'candidate' | head -10

source ~/Projects/catkin_ws/devel/setup.bash
catkin_make --pkg msckf_vio --cmake-args -DCMAKE_BUILD_TYPE=Release
roslaunch msckf_vio msckf_vio_ocams.launch
rosrun rviz rviz -d src/msckf_vio/rviz/rviz_ocams_config.rviz
rosbag play /media/biendltb/HD1/Datasets/DNS/dynamic/ocams_dynamic_2m_3.bag

sudo usermod -a -G dialout biendltb
sudo cat /dev/ttyACM0

docker run -tid --rm -e DISPLAY=$DISPLAY --mount type=bind,source=$PWD,target=/dns-202004 -v /mnt/6e1ef38e-db2f-4eda-ad11-31252df3b87b/data/Datasets:/Datasets -v /usr/lib/nvidia-418:/usr/lib/nvidia-418 -v /usr/lib32/nvidia-418:/usr/lib32/nvidia-418  --net host --name dns-202004-v2  --privileged dynim/backend-build:dns-202004-v2

```
