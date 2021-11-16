# A collection of useful aliases to make terminal life bliss
# Unix
alias ll="ls -la"
alias ln="ln -v"
alias mkdir="mkdir -p"
alias e="$EDITOR"
alias v="$VISUAL"
alias tmux='tmux -u'

# top
alias cpu='top -o CPU'
alias mem='top -o MEM'

# Get your current public IP
alias ip="curl icanhazip.com"
alias ip6="wget -q0- -ti -T2 ipv6.icanhazip.com"

# Git
alias ga="git add"
alias gaa="git add ."
alias gc="git commit -m "
alias gp='git push -u origin "$(git symbolic-ref --short HEAD)"'
alias gs="git status"
alias nah="git reset --hard; git clean -df;"
alias grr="git remote remove origin"
alias gra="git remote add origin "
alias clonerepo="git fetch --all && git pull --all && git clone-branches"

# Bandwhich
alias band="sudo ~/.cargo/bin/bandwhich"

# Python
alias py='python3'
alias py3='python3'
alias python='python3'
alias pip='pip3'

# Bundler
alias b="bundle"
alias bi="bundle install"
alias be="bundle exec"
alias bu="bundle update"

# Rails
alias migrate="rake db:migrate db:rollback && rake db:migrate"
alias s="rspec"
alias rk="rake"
alias rc="rails c"
alias rs="rails s"
alias gi="gem install"

# Rust
alias rcc="rustc"

# Pretty print the path
alias path='echo $PATH | tr -s ":" "\n"'

# Configuration Reloads
alias tmuxreload='source ~/.tmux.conf'
alias zshreload='source ~/.zshrc'

# SSH
# alias sshwork='ssh bridgway@0.0.0.0'

# nvim
alias vim=nvim
alias vi=nvim

# Configuration 
alias vimrc='nvim ~/.vimrc'
alias ealias='nvim ~/dotfiles/aliases.zsh'
alias zshrc='nvim ~/.zshrc'
