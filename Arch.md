# Arch Linux Setup

## Misc
sudo pacman -Syyu  
sudo pacman -S --needed base-devel git  

/etc/X11/xorg.conf.d/00-keyboard.conf  
setxkbmap -option caps:swapescape  

## Paru  
git clone https://aur.archlinux.org/paru.git && cd paru && makepkg -si  
paru && paru -S neovim zsh unzip stow visual-studio-code nerd-fonts-fira-code
// Enable color in /etc/pacman.conf  
// BottomUp in /etc/paru.conf  

## Neovim
sudo rm -rf /bin/vi && sudo ln /bin/nvim /bin/vi

## Stow
// $HOME/dotfiles/nvim/.config/nvim/init.vim
stow zsh git code nvim

## Fonts
https://www.nerdfonts.com/font-downloads  
https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts
mkdir -p /usr/local/share/fonts/nerd-fonts  
mkdir -p .local/share/fonts/nerd-fonts  
fc-cache -vf && fc-match -a familyFontExample  

## Rust

rustc --version  

### Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"  
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k  
// Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc.  



