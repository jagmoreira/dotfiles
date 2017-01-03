#!/usr/bin/env bash

# Finds the location of Sublime Text configurations in several systems

MACOS_DEFAULT="$HOME/Library/Application Support/Sublime Text 3"
LINUX_DEFAULT="$HOME/.config/sublime-text-3"

SUBL=""
if [ "$(uname)" == "Darwin" ]; then
    [ -d "$MACOS_DEFAULT" ] && SUBL="$MACOS_DEFAULT"
elif [ "$(uname)" == "Linux" ]; then
    [ -d "$LINUX_DEFAULT" ] && SUBL="$LINUX_DEFAULT"
fi

echo "$SUBL"
unset SUBL
unset MACOS_DEFAULT
unset LINUX_DEFAULT
