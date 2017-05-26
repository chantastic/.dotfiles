#
# Executes commands at the start of an interactive session.
#

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# aliases
source ~/.aliases

# pco
export PATH="$HOME/pco-box/bin:$PATH"
function pco() {
  if [[ "$1" == "box" ]]; then
    shift
    $HOME/pco-box/bin/box "$@"
  else
    command pco "$@"
  fi
}
eval "$(~/code/pco/bin/pco init -)"

# rbenv
eval "$(rbenv init -)"

# pco-box
# eval "$(pco box alias)"

export PATH="$HOME/.yarn/bin:$PATH"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# git completion for alias
compdef g=git
