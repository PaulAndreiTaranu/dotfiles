# remove duplicat entries from $PATH
# zsh uses $path array along with $PATH
typeset -U PATH path

export PATH=$HOME/scripts:$HOME/dotfiles/scripts:$PATH
