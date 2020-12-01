## Create and run a docker image
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

* Add `--rm` to remove all container's file systems after container exits. By default, the file systems persists so it's suitable for debugging to keep the default. This option is preferred for test and release to keep the container fresh and clean.

```bash
docker run -it --rm test/my_image:v1
```

* Three mount types in docker: **bind mount**, **volume** and **tmpfs** (details: https://docs.docker.com/storage/)
```bash
# "bind mount" gives container access to a directory in file system 
# data could be modified by non-docker process (e.g. Visual Code), thus, prefered to use in development
# (build in container, modified in a GUI IDE)
docker run -itd --mount type=bind,source=$PWD,target=/dir/in/container test/my_image:v1

# "volume" gives the container the access and control a directory in file system
# data is persistent, cannot modifed by non-docker process
# prefered for release or immutable data accessing
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
docker exec -it <container_name> bash
```

#### Stop a running container
Run `docker ps` to see all container names.
```bash
docker stop <container_name>
```

#### Save a modified container to image
```bash
docker commit <container_name or container_id> <new_image_name:v1> 
```

#### Remove all stopped container
```bash
docker rm $(docker ps -a -q)
```

#### Remove an image
```bash
docker rmi <image1> <image2>
```


#### Example commands
* For development
```bash
# init a container and run in background
docker run -itd --name <any_name_you_want> --mount type=bind,source=$PWD,target=/dir/in/container --name my-container test/my_image:v1

# access to the container
docker exec -it <image_name> bash
```
Examples:
```bash
docker run -ti --rm --gpus all -e DISPLAY=$DISPLAY --mount type=bind,source=$PWD,target=/aic_people_counting -v /mnt/6e1ef38e-db2f-4eda-ad11-31252df3b87b/data/Datasets:/Datasets --net host --privileged posesdk:v1
```

* For test/release
```bash
docker run -it --rm -v `pwd`:container/dir test/my_image:v1
```

## Other docker tips
#### Run docker without root permission
1. Create the docker group if it does not exist
    ```
    $ sudo groupadd docker
    ```
2. Add your user to the docker group.
    ```
    $ sudo usermod -aG docker $USER
    ```
3. Run the following command or Logout and login again and run (that doesn't work you may need to reboot your machine first)
    ```
    $ newgrp docker
    ```
4. Reboot if there is still an error

Ref: https://stackoverflow.com/questions/48957195/how-to-fix-docker-got-permission-denied-issue
