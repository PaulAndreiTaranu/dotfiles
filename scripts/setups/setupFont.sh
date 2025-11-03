#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../utils/utils.sh" || { echo "XXX FAILED TO LOAD UTILS.SH"; exit 1; }

function setup_font() {
    local NERD_FONT_NAME="JetBrainsMono"
    local NERD_FONT_LINK="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/$NERD_FONT_NAME.zip"
    local FONTS_DIR="$HOME/.local/share/fonts"
    local FONT_PATH="$FONTS_DIR/$NERD_FONT_NAME"

    # Check if font is already installed
    if [[ -d "$FONT_PATH" ]]; then
        print_red "XXX $NERD_FONT_NAME FONT ALREADY INSTALLED"
        return 0
    fi

    print_green "### SETTING UP $NERD_FONT_NAME FONT"

    # Create fonts directory if it doesn't exist
    if [[ ! -d "$FONTS_DIR" ]]; then
        print_green "### CREATING FONTS DIRECTORY"
        run_as_user "mkdir -p $FONTS_DIR"
    fi

    # Download and install font as normal user
    run_as_user "cd $FONTS_DIR && \
                    wget -q $NERD_FONT_LINK -O font.zip && \
                    unzip -q font.zip -d $NERD_FONT_NAME && \
                    rm -f font.zip"

    print_green "## UPDATING FONT CACHE"
    # Font cache update should run as normal user
    run_as_user "fc-cache -fv $FONTS_DIR"

    print_green "### $NERD_FONT_NAME INSTALLED SUCCESSFULLY!"
}


if [ "${BASH_SOURCE[0]}" -ef "$0" ]; then
    setup_font
fi