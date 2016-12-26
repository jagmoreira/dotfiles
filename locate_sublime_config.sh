#!/usr/bin/env bash

# Finds the location of Sublime Text configurations in several systems

OSX_DEFAULT="$HOME/Library/Application Support/Sublime Text 3"
LINUX_DEFAULT="$HOME/.config/sublime-text-2"

SUBL=""
if [ "$(uname)" == "Darwin" ]; then
    [ -d "$OSX_DEFAULT" ] && SUBL="$OSX_DEFAULT"
elif [ "$(uname)" == "Linux" ]; then
    [ -d "$LINUX_DEFAULT" ] && SUBL="$LINUX_DEFAULT"
fi

echo "$SUBL"
unset SUBL
unset OSX_DEFAULT
unset LINUX_DEFAULT
