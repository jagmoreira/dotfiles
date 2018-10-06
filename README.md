# Joao's dotfiles
My collection of macOS &amp; Linux dotfiles.

This repo will set up:

* Custom bashrc/bash_profile
* Custom terminal prompt
* (Very basic) Screen and Vim configuration
* ipython config and jupyter custom css
* Git configuration
* SSH configuration
* Homebrew with common packages, including Sublime Text 3
* Sublime Text 3 settings and theme


## Installation

1. **Clone repo**: `$ git clone https://github.com/jagmoreira/dotfiles.git`

1. **Run installation script**: `./setup_dev_env.sh`

    Any group of files from the above list can be skipped during installation. The script will prompt you to overwrite any existing dotfiles. During the Git and SSH configurations, you will be prompted for username/email.


## Acknowledgements

When writing my own dotfiles I relied heavily on these great sources:

* Mathias Bynens: [https://github.com/mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
* Nicolas Gallagher: [https://github.com/necolas/dotfiles](https://github.com/necolas/dotfiles)
