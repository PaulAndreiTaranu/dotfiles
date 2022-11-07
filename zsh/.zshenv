# ZSH ENV

# remove duplicat entries from $PATH
# zsh uses $path array along with $PATH
typeset -U PATH path
path+=(~/dotfiles/scripts/**/*/(N/) ~/.cargo/env)
export PATH
