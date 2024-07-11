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
bindkey -e

function recent() { ls -lt $* | head -22; }
function dos2unix() { perl -p -i -e 's/\r\n/\n/' $* }
function over() { cd ../$* }

export PATH="$HOME/bin:$PATH"

# my local machine settings
if [[ -f $HOME/.zshlocal ]]; then
    source $HOME/.zshlocal
fi

# git branch in prompt below uses zsh-git-prompt cloned
if [[ -f $HOME/.zsh-git-prompt/zshrc.sh ]]; then
    export ZSH_THEME_GIT_PROMPT_CACHE=1
    source "$HOME/.zsh-git-prompt/zshrc.sh"
fi

# python pyenv
eval "$(pyenv init --path)"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# pyenv-virtualenv extension
eval "$(pyenv virtualenv-init -)"
# pyenv-virtualenv custom prompt using parameter substitution below instead of default prompt
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

# Custom shell prompt
#
# I want a multi-line prompt with right-justified components on the first line,
# but RPROMPT only works on the last line.  Therefore I have to jump through a lot
# of hoops with the following code which comes from a reddit thread.
#
# Accompanying article:
# https://www.reddit.com/r/zsh/comments/cgbm24/multiline_prompt_the_missing_ingredient/
#
# Example of two-line ZSH prompt with four components.
#
#   top-left                         top-right
#   bottom-left                   bottom-right
#
# Usage: prompt-length TEXT [COLUMNS]
#
# If you run `print -P TEXT`, how many characters will be printed
# on the last line?
#
# Or, equivalently, if you set PROMPT=TEXT with prompt_subst
# option unset, on which column will the cursor be?
#
# The second argument specifies terminal width. Defaults to the
# real terminal width.
#
# The result is stored in REPLY.
#
# Assumes that `%{%}` and `%G` don't lie.
#
# Examples:
#
#   prompt-length ''            => 0
#   prompt-length 'abc'         => 3
#   prompt-length $'abc\nxy'    => 2
#   prompt-length '❎'          => 2
#   prompt-length $'\t'         => 8
#   prompt-length $'\u274E'     => 2
#   prompt-length '%F{red}abc'  => 3
#   prompt-length $'%{a\b%Gb%}' => 1
#   prompt-length '%D'          => 8
#   prompt-length '%1(l..ab)'   => 2
#   prompt-length '%(!.a.)'     => 1 if root, 0 if not
function prompt-length() {
  emulate -L zsh
  local -i COLUMNS=${2:-COLUMNS}
  local -i x y=${#1} m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ))
    done
    while (( y > x + 1 )); do
      (( m = x + (y - x) / 2 ))
      (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  typeset -g REPLY=$x
}

system_name=`( uname -s ) 2>&1`
case "$system_name" in
  Darwin)
    os_icon='🍏'
    ;;
  Linux)
    os_icon='🐧'
    ;;
  FreeBSD)
    os_icon='👿'
    ;;
  *)
    os_icon=''
    ;;
esac

# Usage: fill-line LEFT RIGHT
#
# Sets REPLY to LEFT<spaces>RIGHT with enough spaces in
# the middle to fill a terminal line.
function fill-line() {
  emulate -L zsh
  prompt-length $1
  local -i left_len=REPLY
  prompt-length $2 9999
  local -i right_len=REPLY
  local -i pad_len=$((COLUMNS - left_len - right_len - ${ZLE_RPROMPT_INDENT:-1}))
  if (( pad_len < 1 )); then
    # Not enough space for the right part. Drop it.
    typeset -g REPLY=$1
  else
    local pad=${(pl.$pad_len.. .)}  # pad_len spaces
    typeset -g REPLY=${1}${pad}${2}
  fi
}

# Sets PROMPT and RPROMPT.
#
# Requires: prompt_percent and no_prompt_subst.
function set-prompt() {
  emulate -L zsh

  # example prompt:
  # ~/foo/bar                     master
  # % █                            10:51
  #
  # Top left:      Blue current directory.
  # Top right:     Green Git branch.
  # Bottom left:   '#' if root, '%' if not; green on success, red on error.
  # Bottom right:  Yellow current time.
  #
  #local top_left='%F{blue}%~%f'
  #local top_right="%F{green}${git_branch}%f"
  #local bottom_left='%B%F{%(?.green.red)}%#%f%b '
  #local bottom_right='%F{yellow}%T%f'

  export PYENV_VERSION_NAME=$(pyenv version-name)

  local top_left="%~"
  local top_right="%F{cyan}${PYENV_VERSION_NAME+[$PYENV_VERSION_NAME]}%f $(git_super_status)"
  local bottom_left="${os_icon:+$os_icon }%n@%B%m%b %F{%(?.green.red)}%#%f "

  local REPLY
  fill-line "$top_left" "$top_right"
  PROMPT=$'\n'$REPLY$'\n'$bottom_left
  #RPROMPT=$bottom_right
}

setopt no_prompt_{bang,subst} prompt_{cr,percent,sp}
autoload -Uz add-zsh-hook
add-zsh-hook precmd set-prompt
