## Useful Linux command
#### Check sizes of folders in a directory

```bash
du -sh /home/* 2> /dev/null
```
  
#### Copy files in/out from a server

```bash
scp -P 2222 -r biendltb@dynim.ddns.net:/path/to/source/ /path/to/destination/
```
  
#### Find some files
* Normal find

```bash
find /search/dir/ -name *libtiff*.so*
```

* Ignore error messages (use <code> grep -v </code> to select non-matching lines)

```bash 
find /search/dir/ -name *libtiff*.so* 2>&1 | grep -v "Permission denied"
```

## Docker
#### Create a `Dockerfile`
```dockerfile
# image name from docker hub or name of a local docker image
FROM <image_name_in_docker_hub>

# set variable value (e.g. directory, etc.)
ENV VARIABLE_NAME /dir/or/value/

# copy files to the images (might uses for release image)
COPY /src/dir/ /dir/in/image/or/root/

# set working directory at where following commands will execute
WORKDIR $VARIABLE_NAME

# execute bash commands
RUN any \
    bash \
    command && \
    second \
    command

# reassure that bash are the shell type (use only for images which bash is not the default shell)
CMD ["/bin/bash"]

```

#### Build the docker image
```bash
# add tag name for the docker image. Dockerfile is supposed to stay in the same folder
docker build -t test/my_image:v1 .

# if Dockerfile is stored in other place, use -f to point to Dockerfile
docker build -t test/my_image:v1 -f path/to/Dockerfile .
```

#### Start a container from an image

Before running an image, it's better to see list of images reside in the host machine  
```bash
docker images
```

* Initialise a container from an docker image  
`-it` : pseudo-TTY with STDIN

```bash
docker run -it test/my_image:v1
```

* Add `-d` for run container in background. Regain the access by `docker exec`
```bash
docker run -itd test/my_image:v1
```

* Set name for container to be generated
```bash
docker run -itd --name container_1 test/my_image:v1
```

* Add `--rm` to remove the container after existing (prefered for release or test)

```bash
docker run -it --rm test/my_image:v1
```

* Three mount types in docker: **bin type**, **volume** and **tmpfs** (details: https://docs.docker.com/storage/)
```bash
# "bin type" gives container access to a directory in file system 
# data could be modified by non-docker process (e.g. Visual Code), thus, prefered to use in development
# (build in container, modified in a GUI IDE)
docker run -itd --mount type=bind,source=$PWD,target=/dir/in/container test/my_image:v1

# "volume" gives the container the access and control a directory in file system
# data is persistent, cannot modifed by non-docker process
# prefered for release
docker run -itd -v path/in/host:/path/in/docker test/my_image:v1

# "tmpfs" is very rarely used

```
* Set environment variables
```bash
docker run -it --rm -e VAR=1 test/my_image:v1
```

#### Attach to a running container
Before running `docker exec`, we need to know the container name by run the command: `docker ps`
```bash
docker exec -it <image_name> bash
```

#### Typical commands
* For development
```bash
# init a container and run in background
docker run -itd --name <any_name_you_want> --mount type=bind,source=$PWD,target=/dir/in/container test/my_image:v1

# access to the container
docker exec -it <image_name> bash
```

* For test/release
```bash
docker run -it --rm -v `pwd`:container/dir test/my_image:v1
```

## CMake

* Simple `CMakeLists.txt`

```cmake
cmake_minimum_required(VERSION 3.0)

# set project name and version
project(<project_name> VERSION 1.0)

# specify the C++ standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# find a package with version, `<PackageName>_FOUND` indicates if the package found
# Note: 2.0 could match 2.x, use `EXACT` to find the package in the exact version
# Use `REQUIRED` to show error if package not found, use `QUIET` to ignore
find_package(PackageName 2.0 REQUIRED)
if(NOT PackageName_FOUND)
  message(FATAL_ERROR "PackageName not found")
endif()

# specify place to store the `.so` library of our project
# output library name: `lib<project_name>.so`
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)

# add library: add our own code so that the executable could use when they are compiled
add_library(${PROJECT_NAME} SHARED
src/abc/def.cc
...
)

# link libraries needed to build the project
target_link_libraries(${PROJECT_NAME}
${OpenCV_LIBS}
${EIGEN3_LIBS}
${Pangolin_LIBRARIES}
${PROJECT_SOURCE_DIR}/Thirdparty/DBoW2/lib/libDBoW2.so
${PROJECT_SOURCE_DIR}/Thirdparty/g2o/lib/libg2o.so
)

```
