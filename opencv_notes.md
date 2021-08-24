# C++

### OpenCV installation
Install OpenCV with `opencv_contrib`:
```bash
# Install build tool and dependencies
sudo apt install build-essential cmake git pkg-config libgtk-3-dev libgtk2.0-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev \
    libxvidcore-dev libx264-dev libjpeg-dev libpng-dev libtiff-dev \
    gfortran openexr libatlas-base-dev python3-dev python3-numpy \
    libtbb2 libtbb-dev libdc1394-22-dev libopenexr-dev \
    libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev ffmpeg

# Download lastest version from master branch
wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/master.zip
unzip opencv.zip
unzip opencv_contrib.zip

# Create build directory and switch into it
mkdir -p build && cd build

# Configure
# Note: The OpenCV will be installed to a custom path to not affect the system
cmake -DOPENCV_EXTRA_MODULES_PATH=../opencv_contrib-master/modules \
    -DCMAKE_INSTALL_PREFIX=$HOME/opencv4 \
    ../opencv-master
```

Now take a careful look at the log of cmake to ensure all required modules configured. For example, the video reading ffmpeg should be 'YES':
```txt
--   Video I/O:
--     DC1394:                      YES (2.2.5)
--     FFMPEG:                      YES
--       avcodec:                   YES (58.54.100)
--       avformat:                  YES (58.29.100)
--       avutil:                    YES (56.31.100)
--       swscale:                   YES (5.5.100)
```

After making sure everything is correct, build and install:

```bash
make -j15

make install
```


### Init a writer
```cpp

#include "opencv2/opencv.hpp"

// in a function...

cv::VideoWriter writer;
int codec = cv::VideoWriter::fourcc('M', 'J', 'P', 'G');
double fps = 10.0;
writer.open(dataDir + "/tag_detection.avi", codec, fps, cv::Size(720, 540), true);

// in a loop...
writer.write(frame);

// fisnish
writer.release();
```


# Python
