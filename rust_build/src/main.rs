use std::env;
use std::fs;
use std::process::Command;
use std::io::Write;

fn main() {
    // Function to detect the Linux distribution
    fn detect_linux_distro() -> String {
        if let Ok(os_release) = fs::read_to_string("/etc/os-release") {
            for line in os_release.lines() {
                if line.starts_with("ID=") {
                    return line.split('=').nth(1).unwrap_or("unknown").trim_matches('"').to_string();
                }
            }
        } else if let Ok(lsb_release) = fs::read_to_string("/etc/lsb-release") {
            for line in lsb_release.lines() {
                if line.starts_with("DISTRIBUTOR_ID=") {
                    return line.split('=').nth(1).unwrap_or("unknown").trim_matches('"').to_string();
                }
            }
        } else if fs::metadata("/etc/debian_version").is_ok() {
            return "debian".to_string();
        } else if fs::metadata("/etc/redhat-release").is_ok() {
            return "redhat".to_string();
        }
        "unknown".to_string()
    }

    // Detect the Linux distribution
    let distro = detect_linux_distro();
    let package_manager = match distro.as_str() {
        "fedora" | "rhel" | "centos" => "dnf",
        "debian" | "ubuntu" | "pop" => "apt",
        _ => {
            eprintln!("Unsupported distribution: {}", distro);
            std::process::exit(1);
        }
    };

    // Update system before installing packages
    if package_manager == "dnf" {
        Command::new("sudo").arg("dnf").arg("update").status().expect("Failed to update");
        Command::new("sudo").arg("dnf").arg("upgrade").status().expect("Failed to upgrade");
    } else if package_manager == "apt" {
        Command::new("sudo").arg("apt").arg("update").status().expect("Failed to update");
        Command::new("sudo").arg("apt").arg("upgrade").arg("-y").status().expect("Failed to upgrade");
    }

    // Setup Flatpak
    Command::new("flatpak").arg("remote-add").arg("--if-not-exists").arg("flathub").arg("https://dl.flathub.org/repo/flathub.flatpakrepo").status().expect("Failed to add Flatpak remote");

    let package_list = [
        "btop", "curl", "git", "gh", "fd-find", "flatpak",
        "libfontconfig-dev", "libssl-dev", "neofetch", "python3",
        "python3-pip", "ripgrep", "virt-manager", "zsh"
    ];

    let flatpak_list = [
        "com.bitwarden.desktop", "com.github.tchx84.Flatseal", "com.valvesoftware.Steam",
        "net.davidotek.pupgui2", "net.veloren.airshipper", "org.videolan.VLC"
    ];

    println!("#######################");
    println!("# Installing Packages #");
    println!("#######################");

    for package_name in &package_list {
        if package_manager == "dnf" {
            let output = Command::new("dnf").arg("list").arg("--installed").output().expect("Failed to list installed packages");
            if !String::from_utf8_lossy(&output.stdout).contains(package_name) {
                println!("Installing {}...", package_name);
                std::thread::sleep(std::time::Duration::from_millis(500));
                Command::new("sudo").arg("dnf").arg("install").arg(package_name).arg("-y").status().expect("Failed to install package");
                println!("{} has been installed", package_name);
            } else {
                println!("{} already installed", package_name);
            }
        } else if package_manager == "apt" {
            let output = Command::new("dpkg").arg("-l").output().expect("Failed to list installed packages");
            if !String::from_utf8_lossy(&output.stdout).contains(package_name) {
                println!("Installing {}...", package_name);
                std::thread::sleep(std::time::Duration::from_millis(500));
                Command::new("sudo").arg("apt").arg("install").arg(package_name).arg("-y").status().expect("Failed to install package");
                println!("{} has been installed", package_name);
            } else {
                println!("{} already installed", package_name);
            }
        }
    }

    for flatpak_name in &flatpak_list {
        let output = Command::new("flatpak").arg("list").output().expect("Failed to list Flatpak applications");
        if !String::from_utf8_lossy(&output.stdout).contains(flatpak_name) {
            Command::new("flatpak").arg("install").arg(flatpak_name).arg("-y").status().expect("Failed to install Flatpak application");
        } else {
            println!("{} already installed", flatpak_name);
        }
    }

    println!("###################");
    println!("# Setting up NVIM #");
    println!("###################");

    Command::new("curl").arg("-LO").arg("https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz").status().expect("Failed to download NVIM");
    Command::new("sudo").arg("rm").arg("-rf").arg("/opt/nvim").status().expect("Failed to remove existing NVIM installation");
    Command::new("sudo").arg("tar").arg("-C").arg("/opt").arg("-xzf").arg("nvim-linux64.tar.gz").status().expect("Failed to extract NVIM");

    println!("##########");
    println!("# pynvim #");
    println!("##########");

    Command::new("/usr/bin/python3").arg("-m").arg("pip").arg("install").arg("pynvim").status().expect("Failed to install pynvim");

    println!("#####################");
    println!("# Install Nerd Font #");
    println!("#####################");

    Command::new("wget").arg("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/Hack.zip").status().expect("Failed to download Nerd Font");
    Command::new("unzip").arg("Hack.zip").arg("-d").arg("Hack").status().expect("Failed to unzip Nerd Font");
    fs::create_dir_all("~/.local/share/fonts").expect("Failed to create fonts directory");
    fs::copy("Hack/HackNerdFont-Regular.ttf", "~/.local/share/fonts/HackNerdFont-Regular.ttf").expect("Failed to copy Nerd Font");
    Command::new("fc-cache").arg("-f").arg("-v").status().expect("Failed to update font cache");
    fs::remove_dir_all("Hack*").expect("Failed to remove temporary Hack directory");

    println!("######################");
    println!("# Installing OhMyZSH #");
    println!("######################");

    Command::new("sh").arg("-c").arg("$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)").status().expect("Failed to install OhMyZSH");

    println!("###################");
    println!("# Install Rust Up #");
    println!("###################");

    Command::new("curl").arg("--proto").arg("'=https'").arg("--tlsv1.2").arg("-sSf").arg("https://sh.rustup.rs").arg("|").arg("sh").status().expect("Failed to install Rust Up");

    println!("##################");
    println!("# Setup Starship #");
    println!("##################");

    Command::new("curl").arg("-sS").arg("https://starship.rs/install.sh").arg("|").arg("sh").status().expect("Failed to install Starship");

    println!("###############");
    println!("# Config File #");
    println!("###############");

    fs::copy("terminal/starship.toml", "~/.config/starship.toml").expect("Failed to copy starship config");

    // Symlink files
    let files = [
        "vimrc", "vim", "zshrc", "zsh", "agignore",
        "gitconfig", "gitignore", "gitmessage", "aliases"
    ];

    for file in &files {
        let src = format!("{}/{}", env::current_dir().unwrap().display(), file);
        let dest = format!("{}/.{}", env::var("HOME").unwrap(), file);
        println!("\nSimlinking {} to {}", src, dest);
        if let Err(_) = Command::new("ln").arg("-sf").arg(&src).arg(&dest).status() {
            eprintln!("Failed to symlink {}", file);
            std::process::exit(1);
        } else {
            println!("{} ~> {}", src, dest);
        }
    }
}

