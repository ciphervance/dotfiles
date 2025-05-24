#!/bin/bash

# 03-fedora-dotnet-setup.sh
# Sets up .NET Development Environment specifically for Fedora.
# Assumes it's being run on Fedora and dnf is available.

echo "--- Starting Fedora .NET Development Environment Setup ---"

# Detect current Fedora version
CURRENT_FEDORA_VERSION=$(rpm -E %fedora)
echo "Detected Fedora version: $CURRENT_FEDORA_VERSION"

echo ""
echo "############################################################"
echo "# Fedora Specific: .NET Development Environment Setup      #"
echo "#                                                          #"
echo "# Using Fedora version: $CURRENT_FEDORA_VERSION                                    #"
echo "# If this is a future/unsupported version, some packages   #"
echo "# or repositories might not be available yet.              #"
echo "############################################################"
echo ""

FEDORA_DOTNET_PACKAGES=(
    "postgresql-server"
    "postgresql-contrib"
    "moby-engine" # Docker Engine on Fedora
    "docker-compose" # Note: might be 'podman-compose' on newer Fedora
)

echo "Installing Fedora-specific packages for .NET development..."
for pkg_name in "${FEDORA_DOTNET_PACKAGES[@]}"; do
    if ! rpm -q "$pkg_name" &>/dev/null; then
        echo "Installing $pkg_name..."
        if sudo dnf install -y "$pkg_name"; then
            echo "$pkg_name has been installed."
        else
            echo "WARNING: Failed to install $pkg_name. It may not be available in the repositories."
            # Special handling for docker-compose
            if [ "$pkg_name" == "docker-compose" ]; then
                echo "Trying alternative: podman-compose..."
                if sudo dnf install -y podman-compose; then
                    echo "podman-compose installed as alternative to docker-compose."
                else
                    echo "Neither docker-compose nor podman-compose could be installed."
                fi
            fi
        fi
    else
        echo "$pkg_name is already installed."
    fi
done
echo ""

echo "--------------------------------------------------"
echo "I. Core .NET Development Environment"
echo "--------------------------------------------------"
echo "Registering Microsoft Package Repository..."

MS_REPO_URL_BASE="https://packages.microsoft.com/config/fedora"
FEDORA_VERSION_FOR_MS_REPO="$CURRENT_FEDORA_VERSION"
MS_REPO_RPM_URL="${MS_REPO_URL_BASE}/${FEDORA_VERSION_FOR_MS_REPO}/packages-microsoft-prod.rpm"
MS_GPG_KEY_URL="https://packages.microsoft.com/keys/microsoft.asc"
TEMP_MS_RPM_DIR=$(mktemp -d)
TEMP_MS_RPM_PATH="${TEMP_MS_RPM_DIR}/packages-microsoft-prod-temp.rpm"

if ! sudo dnf repolist enabled | grep -q "packages-microsoft-com-prod"; then
    echo "Importing Microsoft GPG key: $MS_GPG_KEY_URL"
    if sudo rpm --import "$MS_GPG_KEY_URL"; then
        echo "Microsoft GPG key imported successfully."
    else
        echo "WARNING: Failed to import Microsoft GPG key."
    fi
    
    echo "Downloading Microsoft package repository for Fedora $FEDORA_VERSION_FOR_MS_REPO: $MS_REPO_RPM_URL"
    if wget --quiet "$MS_REPO_RPM_URL" -O "$TEMP_MS_RPM_PATH"; then
        echo "Installing downloaded repository configuration..."
        if sudo dnf install -y "$TEMP_MS_RPM_PATH"; then
            echo "Microsoft repository RPM installed."
        else
            echo "ERROR: Failed to install Microsoft repository RPM."
        fi
    else
        echo "ERROR: Failed to download Microsoft repository RPM from $MS_REPO_RPM_URL."
        echo "This might be because Microsoft doesn't yet support Fedora $FEDORA_VERSION_FOR_MS_REPO."
        echo "You can try using a previous Fedora version number or install .NET manually."
        
        # Fallback: try with previous Fedora version
        FALLBACK_VERSION=$((CURRENT_FEDORA_VERSION - 1))
        echo "Trying fallback with Fedora $FALLBACK_VERSION..."
        FALLBACK_URL="${MS_REPO_URL_BASE}/${FALLBACK_VERSION}/packages-microsoft-prod.rpm"
        if wget --quiet "$FALLBACK_URL" -O "$TEMP_MS_RPM_PATH"; then
            echo "Fallback download successful. Installing..."
            sudo dnf install -y "$TEMP_MS_RPM_PATH"
        else
            echo "Fallback also failed. Skipping Microsoft repository setup."
        fi
    fi
    sudo rm -rf "$TEMP_MS_RPM_DIR" # Clean up
else
    echo "Microsoft package repository already configured."
fi

echo "Installing .NET SDK..."
# Try different .NET SDK package names
DOTNET_SDK_PACKAGES=("dotnet-sdk-8.0" "dotnet-sdk-9.0" "dotnet")
DOTNET_INSTALLED=false

for sdk_package in "${DOTNET_SDK_PACKAGES[@]}"; do
    if rpm -q "$sdk_package" &>/dev/null; then
        echo ".NET SDK ($sdk_package) already installed."
        DOTNET_INSTALLED=true
        break
    fi
done

if [ "$DOTNET_INSTALLED" = false ]; then
    for sdk_package in "${DOTNET_SDK_PACKAGES[@]}"; do
        echo "Attempting to install $sdk_package..."
        if sudo dnf install -y "$sdk_package"; then
            echo ".NET SDK ($sdk_package) installed successfully."
            DOTNET_INSTALLED=true
            break
        else
            echo "Failed to install $sdk_package, trying next option..."
        fi
    done
    
    if [ "$DOTNET_INSTALLED" = false ]; then
        echo "ERROR: Failed to install any .NET SDK package."
        echo "You may need to install .NET manually from https://dotnet.microsoft.com/"
    fi
fi

echo "To verify .NET Installation, run these commands manually:"
echo "  dotnet --version"
echo "  dotnet --list-sdks"
echo "  dotnet --list-runtimes"
echo ""

echo "--------------------------------------------------"
echo "II. Code Editor/IDE (Visual Studio Code)"
echo "--------------------------------------------------"
echo "Visual Studio Code (package 'code') should have been installed."
echo "Open VS Code and install these essential extensions from the Extensions view (Ctrl+Shift+X):"
echo "  - C# Dev Kit (Publisher: Microsoft)"
echo "  - (Optional but Recommended) NuGet Package Manager GUI"
echo "  - (Optional but Recommended) GitLens"
echo "  - (Optional but Recommended) Prettier - Code formatter"
echo "  - (Optional) Any Blazor-specific snippet or tooling extensions"
echo "Restart VS Code if prompted after extension installations."
echo ""

echo "--------------------------------------------------"
echo "III. Version Control (Git)"
echo "--------------------------------------------------"
echo "Git (package 'git') should have been installed by 01-package-install.sh."
echo "Configure Git with your details by running these commands:"
echo "  git config --global user.name \"Your Name\""
echo "  git config --global user.email \"youremail@example.com\""
echo ""

echo "--------------------------------------------------"
echo "IV. Web Browser for Frontend Testing"
echo "--------------------------------------------------"
echo "Ensure you have a modern web browser (e.g., Firefox, usually pre-installed on Fedora)."
echo "If needed, you can install Chromium with: sudo dnf install -y chromium"
echo "Familiarize yourself with its Developer Tools (Inspector, Console, Network)."
echo ""

echo "--------------------------------------------------"
echo "V. Database (Optional - PostgreSQL Example)"
echo "--------------------------------------------------"
echo "PostgreSQL server and contrib packages should have been installed."
if command -v postgresql-setup &>/dev/null; then
    echo "Initializing PostgreSQL Database Cluster (if not already done)..."
    # Fixed the postgresql-setup command
    if sudo postgresql-setup --initdb; then
        echo "PostgreSQL database cluster initialized."
    else
        echo "PostgreSQL initialization failed or was already done."
    fi
else
    echo "WARNING: postgresql-setup command not found. Manual initialization might be needed."
fi

echo "Enabling and Starting PostgreSQL Service..."
if sudo systemctl enable --now postgresql; then
    echo "PostgreSQL service enabled and started."
else
    echo "WARNING: Failed to enable/start PostgreSQL service."
fi

echo "To create a PostgreSQL User and Database, run the following commands:"
echo "  1. Access psql: sudo -u postgres psql"
echo "  2. Inside psql, execute (replace placeholders):"
echo "     CREATE USER myappuser WITH PASSWORD 'yoursecurepassword';"
echo "     CREATE DATABASE myappdb OWNER myappuser;"
echo "  3. Exit psql: \\q"
echo "(Optional) Install a PostgreSQL GUI Tool like pgAdmin 4:"
echo "  sudo dnf install -y pgadmin4"
echo "Or DBeaver (download from their website or check Fedora repos/Flathub)."
echo ""

echo "--------------------------------------------------"
echo "VI. Containerization (Optional but Recommended - Docker)"
echo "--------------------------------------------------"
echo "Docker Engine (moby-engine) and Docker Compose should have been installed."
echo "Enabling and Starting Docker Service..."
if sudo systemctl enable --now docker; then
    echo "Docker service enabled and started."
else
    echo "WARNING: Failed to enable/start Docker service."
fi

echo "Adding current user ($USER) to the Docker group..."
if sudo usermod -aG docker "$USER"; then
    echo "User added to docker group successfully."
else
    echo "WARNING: Failed to add user to docker group."
fi

echo "IMPORTANT: You MUST log out and log back in for this group change to take effect."
echo "After logging back in, verify Docker Installation by running:"
echo "  docker --version"
echo "  docker-compose --version (or podman-compose --version)"
echo "  docker run hello-world"
echo ""

echo "--------------------------------------------------"
echo "VII. Final Checks for .NET Setup"
echo "--------------------------------------------------"
echo "Consider rebooting your system to ensure all services and paths are correctly initialized: sudo reboot"
echo "After setup (and potential relogin for Docker), create a Test .NET Project:"
echo "  mkdir -p ~/dotnet_test_projects && cd ~/dotnet_test_projects"
echo "  dotnet new webapi -o TestApi"
echo "  cd TestApi"
echo "  dotnet run  # (and check in browser at http://localhost:5000 or https://localhost:5001)"
echo "  cd .."
echo "  dotnet new blazorserver -o TestBlazorApp # or blazorwasm"
echo "  cd TestBlazorApp"
echo "  dotnet run  # (and check in browser)"
echo ""
echo "############################################################"
echo "# End of Fedora Specific .NET Setup                        #"
echo "############################################################"

echo "--- Fedora .NET Development Environment Setup Finished ---"

