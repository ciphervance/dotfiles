# Fresh Install

This is a collection of items I use when I setup a fresh install.

## Install

./post_install will run a script that installs the software that I use on daily basis, and if you have all the necessary programs installed. If you don't, it installs them for you! Once the dependencies are installed, it will run any third party installations, and create symlinks for the necessary config files in the correct locations.

### Dotfiles

Here's my collection of dotfiles I use on Linux environments. I continuously add to this repo over time, as I customise my dev environment. Feel free to fork this and modify the scripts/dotfiles to suit your own needs!

Git Make sure to edit the gitconfig and add your credentials instead of mine

VIM Installation Tips I use neovim and vim-plug. So if you're using regular vim you might want to remove the neovim specific plugins from my vimrc. Also, you might need to run :PlugClean to remove the plugin directories then run :PlugInstall to reinstall them.

*Things to Remember*  
`~/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install -f`  
`ssh-keygen -t ed25519 -C ${USER}@$(hostname --fqdn)`
