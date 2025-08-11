#!/usr/bin/env bash

# Finds the location of Sublime Text 3/4 configurations in several systems

MACOS_4="$HOME/Library/Application Support/Sublime Text"
MACOS_3="$HOME/Library/Application Support/Sublime Text 3"
LINUX_4="$HOME/.config/sublime-text"
LINUX_3="$HOME/.config/sublime-text-3"

SUBL=""
if [ "$(uname)" == "Darwin" ]; then
    if [ -d "$MACOS_4" ]; then SUBL="$MACOS_4"
    elif [ -d "$MACOS_3" ]; then SUBL="$MACOS_3"
    fi
elif [ "$(uname)" == "Linux" ]; then
    if [ -d "$LINUX_4" ]; then SUBL="$LINUX_4"
    elif [ -d "$LINUX_3" ]; then SUBL="$MACOS_3"
    fi
fi

echo "$SUBL"
unset SUBL
unset MACOS_3
unset MACOS_4
unset LINUX_3
unset LINUX_4
