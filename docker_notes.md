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
