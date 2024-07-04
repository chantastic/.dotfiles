# source Brew Cellar
eval "$(/opt/homebrew/bin/brew shellenv)"

# ruby
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

# node (machine dependent)
if [[ $MACHINE == "work" ]] ; then
  export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
else
  export PATH="/opt/homebrew/opt/node/bin:$PATH"
fi