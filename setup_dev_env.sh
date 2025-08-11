#!/usr/bin/env bash

echo
echo "This script will install a sensible collection of dotfiles and configs"
echo "mostly by sym-linking files from the repo to their expected locations."
echo "You will be prompted for confirmation before each stage."
echo

prompt_user(){
    while true
    do
        read -p "$1 (y/n)? " ANSWER
        case $ANSWER in
            [yY]*) true; return;;
            [nN]*) false; return;;
            *) echo "Please enter y/Y or n/N.";;
        esac
    done
    false
}

# Full directory name where this script is located
# http://stackoverflow.com/a/246128
CWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

if prompt_user "Install bash dotfiles"; then
    echo "Sym-linking dotfiles..."
    ln -isv $CWD/dotfiles/bashrc ~/.bashrc
    ln -isv $CWD/dotfiles/bash_profile ~/.bash_profile
    ln -isv $CWD/dotfiles/bash_prompt ~/.bash_prompt
    ln -isv $CWD/dotfiles/bash_functions ~/.bash_functions
    echo
fi

if prompt_user "Configure screen and vim"; then
    echo "Sym-linking screen and vim configs..."
    ln -isv $CWD/dotfiles/screenrc ~/.screenrc
    ln -isv $CWD/dotfiles/vimrc ~/.vimrc
    echo
fi

if prompt_user "Configure ipython and Jupyter"; then
    echo "Sym-linking ipython and Jupyter configs..."
    # Need to make the ipython folder if it does not exist
    IPYTHON_DIR=~/.ipython/profile_default/
    mkdir -p $IPYTHON_DIR
    ln -isv $CWD/dotfiles/ipython_config.py $IPYTHON_DIR

    # Need to make the jupyter folder if it does not exist
    JUPYTER_DIR=~/.jupyter/custom/
    mkdir -p $JUPYTER_DIR
    ln -isv $CWD/dotfiles/jupyter_custom.css $JUPYTER_DIR/custom.css
    echo
fi

if prompt_user "Configure matplotlib"; then
    # Matplotlib config lives in different places depending on the OS
    if [ "$(uname)" == "Darwin" ]; then
        ln -isv $CWD/dotfiles/matplotlibrc ~/.matplotlib/matplotlibrc
    elif [ "$(uname)" == "Linux" ]; then
        ln -isv $CWD/dotfiles/matplotlibrc ~/.config/matplotlib/matplotlibrc
    fi
    echo
fi

if prompt_user "Configure git"; then
    echo "Sym-linking gitignore..."
    ln -isv $CWD/dotfiles/gitignore ~/.gitignore

    echo "Rsyncing gitconfig..."
    rsync -abi $CWD/dotfiles/gitconfig ~/.gitconfig
    read -p "git username: " GIT_USER
    git config --global user.name "$GIT_USER"
    read -p "git email: " GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
    echo
fi


if prompt_user "Configure ssh"; then
    echo "Configuring ssh..."
    LIVE_SSH_CONFIG=~/.ssh/config
    COMMON_SSH_CONFIG="$CWD/dotfiles/ssh_config"
    if [ ! -e $LIVE_SSH_CONFIG ] || ! grep -q 'Host \*' $LIVE_SSH_CONFIG ; then
        echo >> $LIVE_SSH_CONFIG
        cat $COMMON_SSH_CONFIG >> $LIVE_SSH_CONFIG
    # Backup the ssh config if it already exists
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
fi

if prompt_user "Install Homebrew and some useful packages (macOS only)"; then
    if [ "$(uname)" == "Darwin" ]; then

        # Install homebrew if it does not yet exist
        if ! type brew >/dev/null 2>&1; then
            echo "Installing Homebrew..."
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
            echo "Homebrew appears to be installed already."
        fi

        # Then install the packages using Homebrew-bundle
        echo "Installing some usefull packages from a Brewfile..."
        brew tap Homebrew/bundle
        ln -isv $CWD/Brewfile ~/Brewfile
        brew bundle -v
    fi
    echo
fi

if prompt_user "Configure Sublime Text"; then
    SUBL=$($CWD/locate_sublime_config.sh)
    rsync -itvprhm $CWD/sublime_configs/ "$SUBL"
    echo
fi

if prompt_user "Install pyenv (Linux only)"; then
    if [ "$(uname)" == "Linux" ]; then
        echo "Installing pyenv..."
        curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
    fi
fi

echo "All done!"
