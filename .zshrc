# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases, functions, options, key bindings, etc.
# I use this for universal settings.

alias ls='ls -CFs'
alias mygit='git --git-dir=$HOME/.mygit/ --work-tree=$HOME'

export LESS='CRiM'
export LESSOPEN='|~/.lessfilter %s'

function recent() { ls -lt $* | head -22; }

export PS1=$'\n'"%~"$'\n'"%n@%m %# "
export PATH="$HOME/bin:$PATH"
