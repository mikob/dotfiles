# Per-pane command history.
#
# Every shell still writes each command to the shared $HISTFILE right away and
# picks up the other shells' commands (SHARE_HISTORY), so nothing is lost. What
# changes is the order Up/Down walk through: this shell's own commands come
# first (newest first), then everything else in normal history order. After
# killing a process in a kitty pane, Up brings back that pane's command even if
# other panes ran things since.
#
# This shell's commands are tracked as text, not as history event numbers:
# event numbers are not stable (HISTSIZE trimming, duplicate expiry and
# shared-history imports all renumber or drop events).
setopt SHARE_HISTORY
unsetopt INC_APPEND_HISTORY INC_APPEND_HISTORY_TIME

# Restore the global file if the earlier per-pane configuration was loaded.
if [[ $HISTFILE == "${XDG_STATE_HOME:-$HOME/.local/state}/zsh/kitty/"*.history ]]; then
  fc -A "$HOME/.zsh_history"
  HISTFILE="$HOME/.zsh_history"
  fc -RI
fi

zmodload zsh/zle
autoload -Uz add-zle-hook-widget add-zsh-hook

typeset -ga _pane_history_local            # this shell's commands, oldest first, each once
typeset -gi _pane_history_max=500
# Per-line browsing state, rebuilt lazily on the first Up/Down of each line:
#   index 0 is the line being typed, 1..#view are this shell's commands
#   (newest first), and higher indexes are history events in $path.
typeset -gi _pane_history_ready=0 _pane_history_index=0 _pane_history_origin=0 _pane_history_draft_cursor=0
typeset -ga _pane_history_view _pane_history_path
typeset -gA _pane_history_seen
typeset -g _pane_history_draft

_pane_history_record() {
  local cmd=$1
  [[ -n $cmd ]] || return 0
  [[ $cmd == ' '* && -o HIST_IGNORE_SPACE ]] && return 0
  local -i i=${_pane_history_local[(Ie)$cmd]}
  (( i )) && _pane_history_local[i]=()
  _pane_history_local+=($cmd)
  (( ${#_pane_history_local} > _pane_history_max )) && shift _pane_history_local
  return 0
}

_pane_history_reset() {
  _pane_history_ready=0
}

_pane_history_build() {
  local cmd
  _pane_history_view=(${(Oa)_pane_history_local})
  _pane_history_path=()
  _pane_history_seen=()
  for cmd in "${_pane_history_view[@]}"; do
    _pane_history_seen[$cmd]=1
  done
  _pane_history_index=0
  _pane_history_origin=$HISTNO
  _pane_history_ready=1
}

# Remember edits to the line being left so coming back restores them.
_pane_history_stash() {
  if (( _pane_history_index == 0 )); then
    _pane_history_draft=$BUFFER
    _pane_history_draft_cursor=$CURSOR
  else
    _pane_history_view[_pane_history_index]=$BUFFER
  fi
}

_pane_history_show() {
  if (( _pane_history_index == 0 )); then
    BUFFER=$_pane_history_draft
    CURSOR=$_pane_history_draft_cursor
  else
    BUFFER=$_pane_history_view[_pane_history_index]
    CURSOR=$#BUFFER
  fi
}

# Move one entry: $1 is 1 for older, -1 for newer. Returns 1 at either end.
_pane_history_step() {
  local -i index=$_pane_history_index nlocal=${#_pane_history_view} start=$HISTNO
  if (( $1 > 0 )); then
    if (( index < nlocal )); then
      _pane_history_stash
      (( _pane_history_index = index + 1 ))
      _pane_history_show
      return 0
    fi
    # Past this shell's commands: walk the real history, skipping lines already shown.
    (( index == nlocal )) && _pane_history_stash
    while zle .up-history -n 1; do
      if (( ! ${+_pane_history_seen[$BUFFER]} )); then
        _pane_history_seen[$BUFFER]=1
        _pane_history_path+=($HISTNO)
        (( _pane_history_index = index + 1 ))
        return 0
      fi
    done
    if (( start == _pane_history_origin )); then
      zle .end-of-history
      _pane_history_show
    else
      HISTNO=$start
    fi
    return 1
  fi
  (( index > 0 )) || return 1
  if (( index > nlocal + 1 )); then
    (( _pane_history_index = index - 1 ))
    HISTNO=$_pane_history_path[_pane_history_index - nlocal]
    return 0
  fi
  if (( index == nlocal + 1 )); then
    zle .end-of-history
  else
    _pane_history_stash
  fi
  (( _pane_history_index = index - 1 ))
  _pane_history_show
  return 0
}

_pane_history_move() {
  setopt localoptions nohistbeep
  (( _pane_history_ready )) || _pane_history_build
  local -i dir=$1 n=${NUMERIC:-1}
  (( n < 0 )) && (( dir = -dir, n = -n ))
  while (( n-- > 0 )); do
    _pane_history_step $dir || { zle .beep; return 1 }
  done
  return 0
}

_pane_history_up() {
  if [[ $LBUFFER == *$'\n'* ]]; then
    zle .up-line
  else
    _pane_history_move 1
  fi
}

_pane_history_down() {
  if [[ $RBUFFER == *$'\n'* ]]; then
    zle .down-line
  else
    _pane_history_move -1
  fi
}

add-zsh-hook preexec _pane_history_record
# Reset in precmd as well: add-zle-hook-widget stops running line-init hooks
# after one returns non-zero, and zsh-vim-mode's vim-mode-line-init returns 1,
# so the line-init hook below never runs in this setup.
add-zsh-hook precmd _pane_history_reset
add-zle-hook-widget line-init _pane_history_reset
zle -N up-line-or-history _pane_history_up
zle -N down-line-or-history _pane_history_down
