#!/bin/zsh

which -s brew
if [[ $? != 0 ]]; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Updating brew..."
    brew upgrade
fi
