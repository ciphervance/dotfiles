# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# $GOPATH
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin

GITSTATUS_LOG_LEVEL=DEBUG

DEFAULT_USER="bridgway"

plugins=(git)

# User configuration

export PATH="$PATH:$HOME/.cabal/bin:/opt/cabal/1.22/bin:/opt/ghc/7.10.3/bin:$HOME/.rvm/gems:$HOME/.rvm/bin:$HOME/bin:/usr/local/bin:/usr/local/nwjs:/usr/local/var/postgres"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 

source $ZSH/oh-my-zsh.sh
source $HOME/dotfiles/aliases.zsh
source $HOME/.cargo/env

eval "$(ssh-agent -s)"
ssh-add -A 2>/dev/null;

# Set preferred editor
export EDITOR='vim'

KEYTIMEOUT=1

export CPLUS_INCLUDE_PATH=/usr/local/include

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(starship init zsh)"
