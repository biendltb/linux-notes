## Useful tips for bash
#### Loop through results from find
```bash
for i in $(find -name buffer_epoch.csv); do 
    echo $i 
done
```

#### Substring
```bash
string=YOUR-STRING
echo ${string:<start>}
echo ${string:<start>:<length>}
# remove the last 4 characters (e.g. abc.pdf --> abc)
echo ${string::-4}
```
