# Arch Linux Setup

## Misc
Install Gnome Tweaks, Extension.

## DNF Package Manager
sudo vi /etc/dnf/dnf.conf
* max_parallel_downloads=10
* fastestmirror=True
// Add VSCode, Google Chrome, and postgresql repos

`rpm --import https://packages.microsoft.com/keys/microsoft.asc`
`sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'`

`sudo dnf -y install http://apt.postgresql.org/pub/repos/yum/reporpms/F-36-x86_64/pgdg-fedora-repo-latest.noarch.rpm`

`sudo dnf -y install fedora-workstation-repositories`
`sudo dnf -y config-manager --set-enabled google-chrome`

// Install apps, update all and clean unused dependencies  
`sudo dnf -y install code`
`sudo dnf -y install google-chrome-stable`
`sudo dnf -y postgresql14-server postgresql14-docs`
`sudo dnf -y install kitty zsh neovim`
`sudo dnf -y upgrade && sudo dnf -y autoremove`

## User Fonts  
https://www.nerdfonts.com/font-downloads
https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts  

Create a new directory /usr/local/share/fonts/font-family-name/ for the new font family  
`sudo mkdir -p /usr/local/share/fonts/JetBrainsMono`

Copy font files (e.g. .ttf files) to the new directory  
`sudo cp -a ~/Downloads/JetBrainsMono/. /usr/local/share/fonts/JetBrainsMono`

Update the font cache  
`sudo fc-cache -v`

Check kitty usable fonts  
`kitty +list-fonts`

## ZSH
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
// chsh -s $(which zsh) || usermod --shell $(which zsh) paul
`git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k`
// Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc.  