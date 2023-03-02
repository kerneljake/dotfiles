# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases, functions, options, key bindings, etc.
# I use this for universal settings.

alias ls='ls -CFs'
alias mygit='git --git-dir=$HOME/.mygit/ --work-tree=$HOME'
alias history='history 1'

export LESS=CRiM
export LESSOPEN='|~/.lessfilter %s'
export PAGER=less
export EDITOR=vi

function recent() { ls -lt $* | head -22; }
function dos2unix() { perl -p -i -e 's/\r\n/\n/' $* }
function over() { cd ../$* }

export PS1=$'\n'"%~"$'\n'"%n@%B%m%b %# "
export PATH="$HOME/bin:$PATH"
