# C++

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
