# Set default user
DEFAULT_USER="$USER"

# Environment variables
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Node.js and NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

# Go-specific paths
export PATH="$PATH:/usr/local/go/bin"

# Haskell tools
export PATH="$PATH:$HOME/.cabal/bin"
export PATH="$PATH:/opt/cabal/1.22/bin"
export PATH="$PATH:/opt/ghc/7.10.3/bin"

# Ruby tools
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Neovim
export PATH="$PATH:/opt/nvim-linux64/bin"

# Postgres
export PATH="$PATH:/usr/local/var/postgres"

# Editor
export EDITOR='vim'

# SSH settings
if [ -z "$SSH_AGENT_PID" ]; then
	eval "$(ssh-agent -s)"
	ssh-add -A 2>/dev/null;
fi

# FZF (if installed)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Starship prompt (if installed)
export PATH=$PATH:/home/cipher/.local/bin
eval "$(oh-my-posh init bash --config 'https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/refs/heads/main/themes/clean-detailed.omp.json')"
#eval "$(starship init bash)"

# Bash completion for Git
if [ -f /usr/share/bash-completion/completions/git ]; then
  source /usr/share/bash-completion/completions/git
fi

# Custom aliases (include your existing aliases.zsh content here or source it)
if [ -f "$HOME/dotfiles/aliases.bash" ]; then
  source "$HOME/dotfiles/aliases.bash"
fi

# Key timeout
export KEYTIMEOUT=1

# C++ include path
export CPLUS_INCLUDE_PATH=/usr/local/include

# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return ;;
esac
