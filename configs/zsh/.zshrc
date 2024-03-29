# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

function zvm_config() {
    # Do the initialization when the script is sourced (i.e. Initialize instantly)
    ZVM_INIT_MODE=sourcing
    ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BEAM
    ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLINKING_BLOCK
}

plugins=(zsh-vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# LSD alias
if [[ -e /usr/bin/lsd ]]; then
    alias ls="lsd"
    alias lt="lsd --tree -la"
    alias l="lsd -la"
fi

# Git and LazyGit alias
if [[ -e /usr/bin/lazygit ]]; then
    alias g="git"
    alias gg="lazygit"
fi

# Zellij alias
if [[ -e /snap/bin/zellij ]]; then
    alias z="zellij"
fi

# Docker alias
if [[ -e /usr/bin/docker ]]; then
    alias d="docker"
    alias doccontainerprune="d stop $(d ps -aq) && d container prune --force"
    alias docsystemprune="docker system prune --force --all --volumes"
    alias dc="docker compose"
    alias dcrestart="docker compose down && docker compose up --build"
fi

# Terraform
alias terra="terraform"

# Podman Alias
if [[ -e "/usr/bin/podman" ]]; then
    alias pod='podman'
fi

# Javascript Alias
if [[ -e "$HOME/.local/share/pnpm" ]]; then
    alias p="pnpm"
    alias ps="pnpm start"
    alias pd="pnpm dev"
    alias pt="pnpm test"
    alias pi="pnpm install"
    alias pu="pnpm update --interactive --latest"
    alias pa="pnpm add"
    alias pad="pnpm add --save-dev"
    alias prm="pnpm remove"
    alias pls="pnpm list"
fi

# Python alias
alias poe="poetry"
alias py="python3"

# general alias
alias t="btop"
alias c="clear"
alias r="reset"
alias j="clear && journalctl --since -1m"
alias zshrc="vi $HOME/.zshrc"

## Shortcuts
alias sudopsql="sudo -i -u postgres psql"
alias chmodscripts="find $HOME/dotfiles/scripts -type f -iname '*.sh' -exec chmod +x {} \;"
alias update="sudo apt update -y --allow-insecure-repositories && sudo apt upgrade -y && sudo apt autoremove -y"


## PATH

# remove duplicat entries from $PATH
# zsh uses $path array along with $PATH
typeset -U PATH path
# path+=  ("~/dotfiles/scripts/" "~/dotfiles/scripts/**/*/(N/)" "/root/bin" "~/.cargo/env")
# export PATH=$PATH$(find /home/$USER/dotfiles/scripts -type d -exec printf ":%s" {} +)
path+="$HOME/.cargo/env"
path+="$HOME/.local/bin"
path+="/root/bin"
path+="/usr/local/go/bin"

## NodeJs Version Managers

# NVM
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# N
export N_PREFIX="$HOME/.local/bin/n"
if [[ -e "$N_PREFIX/bin/n" ]]; then
    path+="$HOME/.local/share/pnpm"
    path+="$N_PREFIX/bin"
    # [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
fi

export PATH

## SOURCING RANDOM STUFF

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh