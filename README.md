### My Local Setup
- All themes are in `/themes` to import into terminal, just double click
- Set terminal default theme to `Ayu Mirage`, change cursor color && blink cursor

### Install / Uninstall
- install: `rake`
- uninstall: `rake uninstall`

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


TODO: Add the other necessary things to the rake install:
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
