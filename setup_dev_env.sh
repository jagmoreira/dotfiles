#!/usr/bin/env bash

# Full directory name where this script is located
# http://stackoverflow.com/a/246128
CWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

echo "Sym-linking dotfiles..."
ln -isv $CWD/dotfiles/bashrc ~/.bashrc
ln -isv $CWD/dotfiles/bash_profile ~/.bash_profile
ln -isv $CWD/dotfiles/bash_prompt ~/.bash_prompt
ln -isv $CWD/dotfiles/bash_functions ~/.bash_functions
ln -isv $CWD/dotfiles/screenrc ~/.screenrc
ln -isv $CWD/dotfiles/dir_colors ~/.dir_colors
ln -isv $CWD/dotfiles/gitignore ~/.gitignore
ln -isv $CWD/dotfiles/vimrc ~/.vimrc

# Need to make the ipython folder if it does not exist
IPYTHON_DIR=~/.ipython/profile_default/
mkdir -p $IPYTHON_DIR
ln -isv $CWD/dotfiles/ipython_config $IPYTHON_DIR

# Need to make the jupyter folder if it does not exist
JUPYTER_DIR=~/.jupyter/custom/
mkdir -p $JUPYTER_DIR
ln -isv $CWD/dotfiles/jupyter_custom.css $JUPYTER_DIR/custom.css

# Matplotlib config lives in different places depending on the OS
if [ "$(uname)" == "Darwin" ]; then
    ln -isv $CWD/dotfiles/matplotlibrc ~/.matplotlib/matplotlibrc
elif [ "$(uname)" == "Linux" ]; then
    ln -isv $CWD/dotfiles/matplotlibrc ~/.config/matplotlib/matplotlibrc
fi
echo

echo "Configuring git"
echo "Rsyncing common files..."
rsync -abi $CWD/vc_files/gitconfig ~/.gitconfig

echo "Installing local configuration..."
VC_LOCAL="$CWD/vc_files/vc_settings.local"
VC_TEMPLATE="$CWD/vc_files/vc_settings.template"
if [ -f $VC_LOCAL ]; then
    source $VC_LOCAL
else
    echo "$VC_LOCAL not found. You can create it from the template file:"
    echo
    echo -e "\t$ cp $VC_TEMPLATE $VC_LOCAL"
fi
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

echo "Installing Homebrew and useful packages..."
if [ "$(uname)" == "Darwin" ]; then

    # Install homebrew if it does not yet exist
    if ! type brew >/dev/null 2>&1; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Then install the packages using Homebrew-bundle
    brew tap Homebrew/bundle
    ln -isv $CWD/Brewfile ~/Brewfile
    brew bundle -v
fi
echo

echo "Configuring Sublime Text..."
SUBL=$($CWD/locate_sublime_config.sh)
rsync -itvprhm $CWD/sublime_configs/ "$SUBL"
echo

if [ "$(uname)" == "Linux" ]; then
    echo "Installing pyenv..."
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
fi
echo "done!"

unset CWD
unset IPYTHON_DIR
unset JUPYTER_DIR
unset VC_LOCAL
unset VC_TEMPLATE
unset LIVE_SSH_CONFIG
unset COMMON_SSH_CONFIG
unset SSH_USER
unset SUBL
