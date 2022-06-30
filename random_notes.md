#### Tool for search text in all file in the current directory
Install:
```bash
sudo apt install silversearcher-ag
```
Usage:
```bash
cd /path/to/target/dir
ag <text>
```

### NVIDIA driver / CUDA / CuDNN
* Right after the installation of the system, install NVIDIA driver from as here: http://ubuntuhandbook.org/index.php/2019/03/install-nvidia-418-43-g-sync-support-ubuntu-18-04/
* Download and install CuDNN + Cuda from NVIDIA website (Note: use the `runtime` version).
* Install CUDA toolkit: `sudo apt install nvidia-cuda-toolkit`

### Reinstall CUDA and nvidia-driver
#### Uninstall nvidia drivers
* Show all drivers
```bash
dpkg -l | grep nvidia
```
* Uninstall all of drivers shown in the previous step
```bash
 sudo apt purge <nvidia-packages> 
```
* Reboot the machine
* Download the cuda runtime file which goes with nvidia driver and install

### To disable AMD graphic cards on Ubuntu PC
https://askubuntu.com/questions/771562/16-04-power-off-discrete-graphics-ati-amd

### Touchpad
Disable the annoying touch pad when typing and to have more control on it
Link: https://askubuntu.com/questions/773595/how-can-i-disable-touchpad-while-typing-on-ubuntu-16-04-syndaemon-isnt-working

Code:
```bash
sudo add-apt-repository ppa:atareao/atareao
sudo apt-get update
sudo apt-get install touchpad-indicator
```

### VS Code
* More convenient to switch between editor and integrated terminal
Source: https://stackoverflow.com/questions/42796887/switch-focus-between-editor-and-integrated-terminalgit-in-visual-studio-code
   1) Ctrl + Shift + P
   2) Type `CMD-SHIFT-P -> Preferences: Open Keyboard Shortcuts File (json)`
   3) Add bellow
   ```json
   // Toggle between terminal and editor focus
   { "key": "ctrl+`", "command": "workbench.action.terminal.focus"},
   { "key": "ctrl+`", "command": "workbench.action.focusActiveEditorGroup", "when": "terminalFocus"}

   // Switch between open terminals
   { "key": "ctrl+tab", "command": "workbench.action.terminal.focusNext", "when": "terminalFocus" },
   { "key": "ctrl+tab", "command": "workbench.action.terminal.focusPrevious", "when": "terminalFocus" }
   ```
* Insert a final newline at the end of the file:
   1) Open File > Preferences > Settings
   2) Type "insert final newline" and check the box

### Colorizing the git branch and shorten the directory path in terminal
```bash
# ===== colorising...

function parse_git_branch () {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# colouring bash display
YELLOW="\[\033[0;33m\]"
# Comment in the above and uncomment this below for a color prompt
PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W$YELLOW\$(parse_git_branch)\[\033[00m\]\$ "

# ================
```

## Libraries issues
### glog and ceres
Ceres library has an built-in glog. Include those glogs together in cmake could make them conflict. When using glog with ceres, using the `${CERES_LIBRARIES}` in `target_link_libraries`, it will automatically search for the built-in glog and it would be no conflict.
Glog installed from ubuntu official repository not supported by cmake so it's better installing from source.

