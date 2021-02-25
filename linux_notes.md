# Useful Linux command
### Check sizes of folders in a directory

```bash
du -sh /home/* 2> /dev/null
```
  
### Copy files in/out from a server

```bash
scp -P 2222 -r biendltb@dynim.ddns.net:/path/to/source/ /path/to/destination/
```

### Copy a specific types of file and/or with specific pattern of name
* Case 1: depth level known
```bash
cp /src/**/gnss.csv --parents dest/
# Note: this will result in de directory /dest/src/abc/gnss.csv so make appropriate `cd` inadvance if necessary
```
* Case 2: copy files at any depth
```bash
find /path/to/files -name '*.csv' | cpio -pdm /target
# Note: it will find all of the file in /path/to/files and below and copy them to /target/path/to/files and below.
```

### Safely move directories
```bash
# Copy from A to B by 'rsync', P--> showing progress
sudo rsync -aXSP /src_dir/ /dst_dir/

# check if the copy successfully
sudo diff -r /src_dir/ /dst_dir/

# delete the src_dir
rm -rf /src_dir/

```
  
### Find some files
* Normal find

```bash
find /search/dir/ -name *libtiff*.so*
```

* Ignore error messages (use <code> grep -v </code> to select non-matching lines)

```bash 
find /search/dir/ -name *libtiff*.so* 2>&1 | grep -v "Permission denied"
```

### Uncompress/compress .tar with tar
1. Gzip is a compression tool used to reduce the size of a file
2. Tar is an archiver used to to combine multiple files into one
3. Gzip and Tar are usually used in tandem to create Tarballs that are compressed significantly
4. Extracting an individual file can take a lot longer with zipped tarballs than with other formats

* -x: extract
* -c: Create an archive.
* -z: Compress the archive with gzip.
* -v: Display progress in the terminal while creating the archive, also known as “verbose” mode. The v is always optional in these commands, but it’s helpful.
* -f: Allows you to specify the filename of the archive.

Read more: Difference Between GZIP and TAR | Difference Between http://www.differencebetween.net/technology/difference-between-gzip-and-tar/#ixzz6JTqzTyxm
```bash
# uncompress file
tar -xvzf compressed_file.tar.gz -C /path/to/extraction/dir

# compress file
tar -cvzf arbitrary_name.tar.gz /to/be/compressed/dir/
```

### Mount an external hard drive  
```bash
# Create a folder to mount the HDD to
>> mkdir ~/HDD

# Show all available drives to find the right HDD port (e.g. `/dev/sdb1`)
>> lsblk

# Mount
>> sudo mount /dev/sdb1 ~/HDD

# Do the work ...

# Unmount after use
>> sudo umount ~/HDD
```

## File and text editing

### Reverse lines of a file with `rev`

```bash
rev path/to/file
# example: cut the last 10 characters of every line
rev path/to/file | cut -c -10 | rev
```

### Get the part of lines after a specific string
For example, getting the part of text in a line after `[STAT][imu_pose]:`
```txt
[topics: /rosout, /tf, /ocams/vio/odom, /ocams/vio/feature_point_cloud, /ocams/vio/gt_odom] [STAT][imu_pose]: 1142.630000 29.252804 160.648717 10.042199 0.027129 -0.005577 0.937237 0.347592
```
Command:
```bash
cat ~/.ros/log/latest/rosout.log | sed -n -e 's/^.*\(\[STAT\]\[imu_pose\]: \)//p'
```
Explain:
* `-n` means not to print anything by default.
* `-e` is followed by a sed command.
* `s` is the pattern replacement command.
* The regular expression `^.*\(<search_text>\)`(e.g. `search_text` -> `[STAT][imu_pose]:` in this case) matches the pattern, plus any preceding text (`.*` meaning any text, with an initial `^` to say that the match begins at the beginning of the line). Note that if  occurs several times on the line, this will match the last occurrence.
* The match, i.e. everything on the line up to the `search_text`, is replaced by the empty string (i.e. deleted).
* The final `p` means to print the transformed line.

Referece: https://unix.stackexchange.com/questions/24140/return-only-the-portion-of-a-line-after-a-matching-pattern

## Network tool
### Set LAN IP address
1. Use `ifconfig` to find the name of the network interface that you want to set (e.g. ethernet, wireless, etc.)
2. Use `ifconfig` with root permission to set the IP for the target network interface 
```bash
# network interface could be eth0, enp2s0, etc.
sudo ifconfig <network_interface> 192.168.x.x
```
3. Now you could ping the IP address from another machine which is in a same network

### Create a simple client-server to test the connection with a specific IP/Port with netcat
* Create a simple server listen on a port
```bash
nc -l <ip_address> <port>

#e.g. nc -l localhost 2002
```
  `-l`: listen mode

* Create a simple client to communicate with a running server
```bash
nc <server_ip_address> <sever_port> -v
```

### List all open ports and their status with netstat
```bash
netstat -an
```

### Allow port from firewall with ufw
Check https://linuxize.com/post/how-to-setup-a-firewall-with-ufw-on-ubuntu-18-04/

### Test bandwidth of the connection from board to host machine

```bash
ssh root@192.168.86.22 "dd if=/dev/zero" | dd of=/dev/null status=progress
```
