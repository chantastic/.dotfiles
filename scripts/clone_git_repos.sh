#!/bin/zsh

echo "Cloning git repositories…"

setup_config() {
    if [ -d ~/.config ]; then
        echo ".config installed at path ~/.config"
    else
        echo "installing .config"
        git clone git@github.com:chantastic/.config.git
    fi
}

setup_dotfiles() {
    if [ -d ~/.dotfiles ]; then
        echo ".dotfiles installed at path ~/.dotfiles"
    else
        echo "installing dotfiles"
        git clone git@github.com:chantastic/dotfiles.git ~/.dotfiles
    fi

    rcup -v -d ~/.dotfiles
}

setup_sites() {
    if [ -d ~/sites ]; then
        echo "sites installed at path ~/sites"
    else
        echo "installing sites"
        git clone git@github.com:chantastic/sites.git ~/sites
    fi
}

setup_config
setup_dotfiles
setup_sites
