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

### Install / Uninstall
- install xcode command line tools: `xcode-select --install`
- generate and add ssh key to github:
  - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key
  - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account
```
ssh-keygen -t ed25519 -C "andykallhoff@gmail.com"
eval "$(ssh-agent -s)"
vi ~/.ssh/config
  Host *
    AddKeysToAgent yes
    IdentityFile ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
# on github, add new ssh, paste into the key
```
- set your global gitconfig: `vi ~/.gitconfig`
- make your code directory and cd into it: `mkdir code && cd code/`
- clone this repo: `git clone git@github.com:andykallhoff/local-setup.git`
- install: `rake`
- uninstall: `rake uninstall`
  - note: some things may not be uninstalled fully

### Manual Process
- install xcode
- install rvm
- install homebrew
- install prompt beautifier (starship)
- brew services
  - redis / mysql / postgresql / elasticsearch / node / yarn
- import terminal theme
- setup .zshrc aliases

### Credits
- Maximum Awesome: https://github.com/square/maximum-awesome
- Macos Terminal Themes: https://github.com/lysyi3m/macos-terminal-themes


The below have been added to the rake install.
```
xcode-select --install
\curl -sSL https://get.rvm.io | bash
  # https://rvm.io/rvm/install
brew install starship
  eval "$(starship init zsh)" #~/.zshrc it should already be in there
  # https://starship.rs/guide/#%F0%9F%9A%80-installation
brew tap homebrew/services
brew install node
brew install yarn
brew install redis
  brew services start redis
brew install mysql
  brew services start mysql
brew install postgresql
  brew services start postgresql
brew install elasticsearch
  brew services start elasticsearch
```
