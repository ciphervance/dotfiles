**Fedora 42 DotNet Setup Checklist**

**Important Preliminary Note:**
*   [ ] **Fedora 42 Specifics:** Since Fedora 42 is a future release, always double-check the *exact* package names and commands against the official Fedora and Microsoft documentation once Fedora 42 is available. The commands below are based on current Fedora practices.

---

**I. Core .NET Development Environment**

*   [ ] **Register Microsoft Package Repository:**
    *   [ ] Import Microsoft GPG key (e.g., `sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc`).
    *   [ ] Add Microsoft package repository for Fedora 42 (e.g., `sudo wget https://packages.microsoft.com/config/fedora/42/packages-microsoft-prod.rpm -O packages-microsoft-prod.rpm` - *verify exact URL for F42*).
    *   [ ] Install the downloaded repository configuration (e.g., `sudo dnf install -y packages-microsoft-prod.rpm`).
    *   [ ] Clean up downloaded .rpm file (e.g., `rm packages-microsoft-prod.rpm`).
*   [ ] **Install .NET SDK:**
    *   [ ] Install the desired .NET SDK version (e.g., `sudo dnf install -y dotnet-sdk-8.0` or latest LTS).
*   [ ] **Verify .NET Installation:**
    *   [ ] Check SDK version: `dotnet --version`
    *   [ ] List installed SDKs: `dotnet --list-sdks`
    *   [ ] List installed runtimes: `dotnet --list-runtimes`

---

**II. Code Editor/IDE (Visual Studio Code Recommended)**

*   [ ] **Install Visual Studio Code:**
    *   [ ] Option A: From Fedora repositories (e.g., `sudo dnf install -y code`).
    *   [ ] Option B: Download `.rpm` from [code.visualstudio.com](https://code.visualstudio.com/) and install (e.g., `sudo dnf install -y ./<vscode_downloaded_file>.rpm`).
*   [ ] **Install Essential VS Code Extensions (Open VS Code to do this):**
    *   [ ] **C# Dev Kit** (from Microsoft - this is key and bundles other C# tools).
    *   [ ] (Optional but Recommended) NuGet Package Manager GUI.
    *   [ ] (Optional but Recommended) GitLens.
    *   [ ] (Optional but Recommended) Prettier - Code formatter.
    *   [ ] (Optional) Any Blazor-specific snippet or tooling extensions you find useful.
    *   [ ] *Restart VS Code if prompted after extension installations.*

---

**III. Version Control**

*   [ ] **Install Git:**
    *   [ ] `sudo dnf install -y git`
*   [ ] **Configure Git (Global Settings):**
    *   [ ] Set user name: `git config --global user.name "Your Name"`
    *   [ ] Set user email: `git config --global user.email "youremail@example.com"`

---

**IV. Web Browser for Frontend Testing**

*   [ ] **Install/Verify Modern Web Browser:**
    *   [ ] Firefox (usually pre-installed on Fedora).
    *   [ ] Or, install another like Chromium (e.g., `sudo dnf install -y chromium`) or Google Chrome.
    *   [ ] *Familiarize yourself with its Developer Tools (Inspector, Console, Network).*

---

**V. Database (Optional - PostgreSQL Example)**

*   [ ] **Install PostgreSQL Server & Contrib Packages:**
    *   [ ] `sudo dnf install -y postgresql-server postgresql-contrib`
*   [ ] **Initialize PostgreSQL Database Cluster:**
    *   [ ] `sudo postgresql-setup --initdb`
*   [ ] **Enable and Start PostgreSQL Service:**
    *   [ ] `sudo systemctl enable --now postgresql`
*   [ ] **Create PostgreSQL User and Database (via `psql`):**
    *   [ ] Access `psql`: `sudo -u postgres psql`
    *   [ ] Create user: `CREATE USER myappuser WITH PASSWORD 'yoursecurepassword';` (Replace with your details)
    *   [ ] Create database: `CREATE DATABASE myappdb OWNER myappuser;` (Replace with your details)
    *   [ ] Exit `psql`: `\q`
*   [ ] **(Optional) Install PostgreSQL GUI Tool:**
    *   [ ] e.g., pgAdmin 4: `sudo dnf install -y pgadmin4`
    *   [ ] Or DBeaver (download from their website or check Fedora repos).

---

**VI. Containerization (Optional but Recommended)**

*   [ ] **Install Docker Engine (moby-engine on Fedora):**
    *   [ ] `sudo dnf install -y moby-engine`
*   [ ] **Enable and Start Docker Service:**
    *   [ ] `sudo systemctl enable --now docker`
*   [ ] **Add User to Docker Group:**
    *   [ ] `sudo usermod -aG docker $USER`
    *   [ ] **IMPORTANT: Log out and log back in for this group change to take effect.**
*   [ ] **Install Docker Compose:**
    *   [ ] `sudo dnf install -y docker-compose` (or check official Docker docs for other methods if needed).
*   [ ] **Verify Docker Installation:**
    *   [ ] `docker --version`
    *   [ ] `docker-compose --version`
    *   [ ] `docker run hello-world` (after logging back in)

---

**VII. Final Checks**

*   [ ] **Reboot (Optional but can ensure all services/paths are correctly initialized):**
    *   [ ] `sudo reboot`
*   [ ] **Create a Test Project:**
    *   [ ] `dotnet new webapi -o TestApi`
    *   [ ] `cd TestApi`
    *   [ ] `dotnet run` (and check in browser)
    *   [ ] `dotnet new blazorserver -o TestBlazorApp` (or `blazorwasm`)
    *   [ ] `cd TestBlazorApp`
    *   [ ] `dotnet run` (and check in browser)
