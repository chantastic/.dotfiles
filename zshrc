# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# aliases
source ~/.aliases

# pco
eval "$(~/code/pco/bin/pco init -)"

# rbenv
eval "$(rbenv init -)"

# pco-box
# eval "$(pco box alias)"

export PATH="$HOME/.yarn/bin:$PATH"
