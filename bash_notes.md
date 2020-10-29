## Useful tips for bash
### Brackets
* Single Parenthesis - ( ... ) is creating a subshell; variables declared in this subshell won't exist after passed
    ```bash
    a='This string'
    ( a=banana; mkdir $a )
    echo $a
    # => 'This string'
    ls
    # => ...
    # => banana/
    ```
   It could also be used for creating an array (Note: it's 1-based index array)
   ```bash
    cheeses=('cheddar' 'swiss' 'provolone' 'brie')
    echo "${cheeses[2]}"
    # => swiss
    # Add items to array
    cheeses+='american'
   ```
* Double Parenthesis - (( ... )) is for arithmetic operation
    ```bash
    if (($i > 3)); then
        ...
    fi
    ```
* Single curly brace - { ... } is for list and expansion
    * Use for **expansion**
    ```bash
    echo h{a,e,i,o,u}p
    # => hap hep hip hop hup
    echo "I am "{cool,great,awesome}
    # => I am cool I am great I am awesome

    mv friends.txt{,.bak}
    # mv friends.txt friends.txt.bak
    ```
    * Make ranges (even with **leading zeros**)
    ```bash
    echo {01..10}
    # 01 02 03 04 05 06 07 08 09 10
    echo {01..10..3}
    # 01 04 07 10
    ```
    * Group commands
    ```bash
    [[ "$1" == secret ]] && {echo "The fox flies at midnight"; echo "Ssssshhhh..."}
    ```
* Single Square Bracket - [ ... ] is the syntax for the POSIX test
* Double Square Brackets - [[ ... ]] is the syntax for bash conditional expressions (similar to test but more powerful)

Reference: https://www.assertnotmagic.com/2018/06/20/bash-brackets-quick-reference/


#### Loop through results from find
```bash
for i in $(find -name buffer_epoch.csv); do 
    echo $i 
done
```

#### Loop through a list
```bash
for i in {00,12,13}; do 
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
