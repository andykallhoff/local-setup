### My Local Setup
- All themes are in `/themes` to import into terminal, just double click
- Double click `Ayu Mirage`, then go to terminal preferences
  - set as default theme
  - change background colors:
    - (change tab to RGB Sliders) `R49 G57 B75`, or `Hex: 31394B`
    - opacity 93%
    - blur 50%
  - change text selection colors:
    - (change tab to RGB Sliders) `R110 G117 B130`, or `Hex: 6E7582`
    - opacity 84%
  - change cursor:
    - `Hex: FF9500`
    - blink cursor

### Install
- install xcode command line tools: `xcode-select --install`
- generate and add ssh key to github:
  - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
  - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
```
ssh-keygen -t ed25519 -C "andykallhoff@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
# on github, add new ssh, paste into the key
```
- set your global gitconfig: `vi ~/.gitconfig`
```
[user]
	name = Andy Kallhoff
	email = andykallhoff@gmail.com
```
- make your code directory and cd into it: `mkdir code && cd code/`
- clone this repo: `git clone git@github.com:andykallhoff/local-setup.git`
- install: `rake`


### Uninstall
- uninstall: `rake uninstall`
- Note: some things may not be uninstalled fully

### Credits
- Maximum Awesome: https://github.com/square/maximum-awesome
- Macos Terminal Themes: https://github.com/lysyi3m/macos-terminal-themes

**Notes when resetting entire machine**
```
System Preferences
- dock and menu bar
  - bar adjustments
  - top menu bar icons
- display
- notifications off
- trackpad / mouse
- keyboard
  - modifier keys > capslock -> control
  - input sources > chinese -> opt + cmd + space
- mission control > hot corners
- wifi
  - ask to join
  - dns

Desktop
- desktop display preferences
- finder preferences

Applications
- chrome
- firefox
- folx
- express vpn
- atom
- wireguard
- bitwarden
- vlc
- postico / other mysql things
```
