#!/usr/bin/env bash

# Full directory name where this script is located
# http://stackoverflow.com/a/246128
CWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Sym-linking dotfiles..."
ln -sv $CWD/dotfiles/bashrc ~/.bashrc
ln -sv $CWD/dotfiles/bash_profile ~/.bash_profile
ln -sv $CWD/dotfiles/bash_prompt ~/.bash_prompt
ln -sv $CWD/dotfiles/bash_functions ~/.bash_functions
ln -sv $CWD/dotfiles/screenrc ~/.screenrc
ln -sv $CWD/dotfiles/dir_colors ~/.dir_colors
ln -sv $CWD/dotfiles/gitignore ~/.gitignore
ln -sv $CWD/dotfiles/vimrc ~/.vimrc

# Matplotlib config lives in different places depending on the os
if [ "$(uname)" == "Darwin" ]; then
    ln -sv $CWD/dotfiles/matplotlibrc ~/.matplotlib/matplotlibrc
elif [ "$(uname)" == "Linux" ]; then
    ln -sv $CWD/dotfiles/matplotlibrc ~/.config/matplotlib/matplotlibrc
fi
echo

echo "Configuring git/mercurial"
echo "Rsyncing common files..."
rsync -abi $CWD/vc_files/hgrc ~/.hgrc
rsync -abi $CWD/vc_files/gitconfig ~/.gitconfig

echo "Installing local configuration..."
VC_LOCAL="$CWD/vc_files/vc_settings.local"
[ -f $VC_LOCAL ] && source $VC_LOCAL
echo

echo "Configuring ssh..."
LIVE_SSH_CONFIG=~/.ssh/config
COMMON_SSH_CONFIG="$CWD/dotfiles/ssh_config"
if [ ! -e $LIVE_SSH_CONFIG ] || ! grep -q 'Host \*' $LIVE_SSH_CONFIG ; then
    echo >> $LIVE_SSH_CONFIG
    cat $COMMON_SSH_CONFIG >> $LIVE_SSH_CONFIG
else
    sed -i.bak "/Host \*/{
        r $COMMON_SSH_CONFIG
        d
    }" $LIVE_SSH_CONFIG
fi
read -p "Common username for 'ssh' commands? [Default: $USER] " SSH_USER
[ -z "$SSH_USER" ] && SSH_USER=$USER
echo -e "\tUser $SSH_USER" >> $LIVE_SSH_CONFIG
echo

echo "Installing Homebrew and useful formulae..."
if [ "$(uname)" == "Darwin" ]; then

    # Install homebrew if it does not yet exist
    if ! type brew >/dev/null 2>&1; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Then install the formulae using Homebrew-bundle
    brew tap Homebrew/bundle
    ln -sv $CWD/Brewfile ~/Brewfile
    brew bundle -v
fi
echo

echo "Configuring Sublime Text..."
SUBL=$($CWD/locate_sublime_config.sh)
rsync -itvprhm $CWD/sublime_configs/ "$SUBL"
echo "done!"

unset CWD
unset SUBL
unset VC_LOCAL
unset COMMON_SSH_CONFIG
unset LIVE_SSH_CONFIG
unset SSH_USER
