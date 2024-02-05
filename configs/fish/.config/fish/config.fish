set -g fish_greeting ''

if status is-interactive
    fish_vi_key_bindings
    # Emulates vim's cursor shape behavior
    # Set the normal and visual mode cursors to a block
    set fish_cursor_default block
    # Set the insert mode cursor to a line
    set fish_cursor_insert line blink
    # Set the replace mode cursors to an underscore
    set fish_cursor_replace_one underscore blink
    set fish_cursor_replace underscore blink
    # Set the external cursor to a line. The external cursor appears when a command is started.
    # The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
    set fish_cursor_external line blink
    # The following variable can be used to configure cursor shape in
    # visual mode, but due to fish_cursor_default, is redundant here
    set fish_cursor_visual block

    # General Alias
    alias l='lsd -la'
    alias ls='lsd'
    alias lt='lsd -la --tree'
    alias md="mkdir -p"
    alias zz='zellij'
    alias za='zellij a --force-run-commands'

    # GIT Alias
    alias g='git'
    alias gg='lazygit'
    
    # Javascript Alias
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

    # Python alias
    alias poe="poetry"
    alias poed="poetry add -G dev"
    alias py="python3"

    # general alias
    alias t="btop"
    alias r="reset"
    alias j="clear && journalctl --since -1m"

    ## Shortcuts
    alias sudopsql="sudo -i -u postgres psql"
    alias chmodscripts="find $HOME/dotfiles/scripts -type f -iname '*.sh' -exec chmod +x {} \;"
    alias update="sudo apt update -y --allow-insecure-repositories && sudo apt upgrade -y && sudo apt autoremove -y"
end



fish_add_path $HOME/dotfiles/scripts/bin
fish_add_path $HOME/.local/bin

starship init fish | source

set -x N_PREFIX "$HOME/n"; contains "$N_PREFIX/bin" $PATH; or set -a PATH "$N_PREFIX/bin"  # Added by n-install (see http://git.io/n-install-repo).
