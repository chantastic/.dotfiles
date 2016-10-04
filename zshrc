# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# aliases
source ~/.aliases

# pco
eval "$(~/code/pco/bin/pco init -)"

# pco-box
# eval "$(pco box alias)"
