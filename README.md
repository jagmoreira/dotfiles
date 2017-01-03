# Joao's dotfiles
My collection of macOS &amp; Linux dotfiles.

This repo will set up:

* Custom bashrc/bash_profile
* Custom terminal prompt
* (Very basic) Screen and Vim configuration
* Git/Mercurial configuration
* SSH configuration
* Homebrew with common packages, including Sublime Text 3
* Sublime Text 3 settings and theme


## Installation

1. **Clone repo**: `$ git clone https://github.com/jagmoreira/dotfiles.git`

1. **Customize version control**: `$ cp vc_files/vc_settings.template vc_files/vc_settings.local`

    Edit local version control settings to match your needs. Here's a sample:

        # Version control settings
        # Not in the repository, to prevent people from accidentally committing under my name

        # Git credentials
        git config --global user.name "John Doe"
        git config --global user.email "john.doe@mail.com"

        # Mercural credentials
        echo '' >> ~/.hgrc
        echo '[ui]' >> ~/.hgrc
        echo 'username = Jonh Doe <doe@mail.com>' >> ~/.hgrc
        echo '[trusted]' >> ~/.hgrc
        echo 'users = john_doe' >> ~/.hgrc
        echo 'groups = john_doe' >> ~/.hgrc

1. **Run installation script**: `./setup_dev_env.sh`

    Throughout the installation the script will prompt you to overwrite any existing dotfiles and for your common ssh username.


## Acknowledgements

When writing my own dotfiles I relied heavily on these great sources:

* Mathias Bynens: [https://github.com/mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
* Nicolas Gallagher: [https://github.com/necolas/dotfiles](https://github.com/necolas/dotfiles)
