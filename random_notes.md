### NVIDIA driver / CUDA / CuDNN
* Right after the installation of the system, install NVIDIA driver from as here: http://ubuntuhandbook.org/index.php/2019/03/install-nvidia-418-43-g-sync-support-ubuntu-18-04/
* Download and install CuDNN + Cuda from NVIDIA website (Note: use the `runtime` version).
* Install CUDA toolkit: `sudo apt install nvidia-cuda-toolkit`

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
Source: https://stackoverflow.com/questions/42796887/switch-focus-between-editor-and-integrated-terminal-in-visual-studio-code
1) Ctrl + Shift + P
2) Type `CMD-SHIFT-P -> Preferences: Open Keyboard Shortcuts File (json)`
3) Add bellow
```json
// Toggle between terminal and editor focus
{ "key": "ctrl+`", "command": "workbench.action.terminal.focus"},
{ "key": "ctrl+`", "command": "workbench.action.focusActiveEditorGroup", "when": "terminalFocus"}
```
