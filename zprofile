# source Brew Cellar
eval "$(/opt/homebrew/bin/brew shellenv)"

# source Volta for Node.js
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"