#
# Executes commands at the start of an interactive session.
#

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# aliases
source ~/.aliases

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

# pco-box environment
export RBENV_ROOT=$HOME/.rbenv
export MYSQL_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_SLAVE_PORT_3306_TCP_ADDR=127.0.0.1
export MYSQL_SLAVE_PORT_3306_TCP_PORT=3307
export PATH=/Users/chan/pco-box/bin:/usr/local/bin:$PATH
