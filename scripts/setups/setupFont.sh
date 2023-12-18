#!/usr/bin/env bash

SCRIPTS="$HOME/dotfiles/scripts"
. $SCRIPTS/utils/utils.sh
check_sudo

function setup_font() {
    NERD_FONT_NAME=JetBrainsMono
    NERD_FONT_LINK="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/$NERD_FONT_NAME.zip"
    FONTS_DIR="$HOME/.local/share/fonts"

    print_green "### SETTING UP $NERD_FONT_NAME FONT"

    as_normal_user "mkdir $FONTS_DIR"
    as_normal_user "cd $FONTS_DIR && wget $NERD_FONT_LINK -O font.zip"
    as_normal_user "cd $FONTS_DIR && unzip font.zip -d $NERD_FONT_NAME"
    as_normal_user "cd $FONTS_DIR && rm -rf font.zip"
}

if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_font
fi
