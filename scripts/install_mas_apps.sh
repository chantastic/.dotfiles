#!/bin/zsh

# https://github.com/mas-cli/mas
echo "Installing Mac App Store apps…"

MAS_APPS=(
    # "-2143728525" # Klack, not sure why i'm getting an invalid negative id here
    441258766  # Magnet
    904280696  # Things 3
    1365531024 # 1Blocker
    1452453066 # Hidden Bar
    1569813296 # 1Password for Safari
    1616822987 # Affinity Photo 2
    1616831348 # Affinity Designer 2
    1606941598 # Affinity Publisher 2
)

mas install ${MAS_APPS[@]}
