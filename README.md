# Fresh Install

This is a collection of scripts and dotfiles I use when setting up a fresh Linux installation.

## Quick Start

Run the main setup script to install software, configure development tools, and symlink dotfiles:

```bash
./main-setup.sh
```

The script will automatically detect your Linux distribution (Fedora, Ubuntu, Debian, etc.) and use the appropriate package manager.

## What Gets Installed

### Core Packages
- Development tools: `git`, `gh`, `curl`, `wget`, `ripgrep`, `fd-find`
- System utilities: `btop`, `fastfetch`, `zsh`, `flatpak`
- Virtualization: `virt-manager`
- Python: `python3`, `python3-pip`

### Development Environment
- **Neovim** (latest version from GitHub)
- **Hack Nerd Font** for terminal
- **Oh My Zsh** shell framework
- **Starship** prompt
- **Rust** toolchain via rustup

### Fedora-Specific (.NET Development)
On Fedora systems, additional packages are installed:
- **Visual Studio Code**
- **.NET SDK** (with Microsoft repository)
- **PostgreSQL** server and tools
- **Docker** (moby-engine) with Docker Compose

### Flatpak Applications
- Bitwarden
- Flatseal
- Steam
- ProtonUp-Qt
- Rider
- Veloren Airshipper
- Visual Studio Code
- VLC Media Player

## Modular Architecture

The setup is broken down into focused scripts:

- `00-system-prep.sh` - System updates and Flathub setup
- `01-package-install.sh` - Core packages and Flatpak apps
- `02-dev-tools-setup.sh` - Development tools (Neovim, fonts, shell)
- `03-fedora-dotnet-setup.sh` - Fedora-specific .NET environment
- `04-config-symlinks.sh` - Dotfile symlinking

You can run individual scripts if you only need specific components.

## Dotfiles

The following configuration files will be symlinked to your home directory:

- `.vimrc` & `.vim/` - Vim/Neovim configuration
- `.zshrc` & `.zsh/` - Zsh shell configuration  
- `.gitconfig` - Git configuration (**edit with your credentials**)
- `.gitignore` - Global Git ignore patterns
- `.agignore` - Silver Searcher ignore patterns
- `.aliases` - Shell aliases (from `aliases.zsh`)
- `.gitmessage` - Git commit template (from `commit-conventions.txt`)

### Git Configuration

**Important:** Edit `gitconfig` and replace my credentials with yours before running the setup.

### Vim/Neovim Setup

I use Neovim with vim-plug for plugin management. If you're using regular Vim, you may need to:
1. Remove Neovim-specific plugins from `.vimrc`
2. Run `:PlugClean` to remove plugin directories
3. Run `:PlugInstall` to reinstall compatible plugins

## Post-Installation Tasks

After running the setup, remember to:

1. **Configure Git with your details:**
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Generate SSH key:**
   ```bash
   ssh-keygen -t ed25519 -C ${USER}@$(hostname --fqdn)
   ```

3. **Install Powerlevel10k gitstatus (if using):**
   ```bash
   ~/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/install -f
   ```

4. **Log out and back in** for Docker group changes to take effect (Fedora)

5. **Install VS Code extensions** (Fedora):
   - C# Dev Kit
   - GitLens
   - Prettier
   - NuGet Package Manager GUI

## Supported Distributions

- **Fedora** (with full .NET development environment)
- **Ubuntu/Debian** (core packages and development tools)
- **Pop!_OS** (core packages and development tools)

## Customization

Feel free to fork this repository and modify the scripts/dotfiles to suit your needs. The modular structure makes it easy to add, remove, or modify specific components.

## Legacy

The original monolithic `post_install.sh` script has been archived in `.archive/` for reference.

