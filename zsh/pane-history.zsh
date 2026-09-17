# Write each command immediately and import shared history before each prompt.
# Keep duplicate events in memory so an imported command cannot delete a local one.
unsetopt SHARE_HISTORY INC_APPEND_HISTORY_TIME HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY

# Restore the global file if the earlier per-pane configuration was loaded.
if [[ $HISTFILE == "${XDG_STATE_HOME:-$HOME/.local/state}/zsh/kitty/"*.history ]]; then
  fc -A "$HOME/.zsh_history"
  HISTFILE="$HOME/.zsh_history"
  fc -RI
fi

zmodload zsh/parameter zsh/zle
autoload -Uz add-zle-hook-widget add-zsh-hook
typeset -ga _pane_history_order
typeset -gA _pane_history_local
typeset -g _pane_history_draft
typeset -gi _pane_history_ready=0 _pane_history_origin=0 _pane_history_draft_cursor=0

_pane_history_record() {
  # Record event IDs, not just command text: another pane may run the same command.
  if (( ${+history[$HISTCMD]} )); then
    _pane_history_local[$HISTCMD]=$history[$HISTCMD]
  fi
}

_pane_history_reset() {
  _pane_history_ready=0
}

_pane_history_refresh() {
  _pane_history_ready=0
  [[ -r $HISTFILE ]] && fc -RI
  return 0
}

_pane_history_build() {
  local deduplicate=$options[histfindnodups]
  emulate -L zsh
  unsetopt HIST_BEEP
  local saved_buffer=$BUFFER
  local -i saved_cursor=$CURSOR saved_histno=$HISTNO
  local -a local_events global_events
  local -A seen
  local event command_text

  zle .end-of-history
  _pane_history_origin=$HISTNO

  for event in ${(k)_pane_history_local}; do
    if [[ ${history[$event]-} != $_pane_history_local[$event] ]]; then
      unset "_pane_history_local[$event]"
    fi
  done
  for event in ${(Onk)history}; do
    (( event < _pane_history_origin )) || continue
    if (( ${+_pane_history_local[$event]} )); then
      local_events+=($event)
    else
      global_events+=($event)
    fi
  done
  _pane_history_order=()
  for event in "${local_events[@]}" "${global_events[@]}"; do
    command_text=$history[$event]
    if [[ $deduplicate != on ]] || (( ! ${+seen[$command_text]} )); then
      _pane_history_order+=($event)
      seen[$command_text]=1
    fi
  done
  _pane_history_ready=1

  HISTNO=$saved_histno
  BUFFER=$saved_buffer
  CURSOR=$saved_cursor
}

_pane_history_move() {
  (( _pane_history_ready )) || _pane_history_build
  local -i index=${_pane_history_order[(Ie)$HISTNO]}
  local -i target=$(( index + $1 * ${NUMERIC:-1} ))
  if (( HISTNO == _pane_history_origin )); then
    _pane_history_draft=$BUFFER
    _pane_history_draft_cursor=$CURSOR
  fi
  if (( target < 0 || target > ${#_pane_history_order} )); then
    zle .beep
    return 1
  fi
  if (( target == 0 )); then
    zle .end-of-history
    BUFFER=$_pane_history_draft
    CURSOR=$_pane_history_draft_cursor
  else
    HISTNO=${_pane_history_order[$target]}
  fi
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
add-zsh-hook precmd _pane_history_refresh
add-zle-hook-widget line-init _pane_history_reset
zle -N up-line-or-history _pane_history_up
zle -N down-line-or-history _pane_history_down
