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
